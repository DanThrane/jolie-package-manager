# Concrete Example with Configuration

As an example, consider this small system of services. The calculator service
fill function as a client of the two others, and its primary function is to
apply an operator to a sequence of numbers. The two other services will only
apply the operator on two operands.

    +-----------------+   +-----------------+
    | calculator      |-->| multiplication  |
    +-----------------+   +-----------------+
             |
             v
    +-----------------+
    | addition        |
    +-----------------+

To create this system, we will create a number of packages, which split up the
interface from its implementation. We end up creating the following packages:

| Package name   | Description                                                |
|----------------|------------------------------------------------------------|
| mult-stub      | Provides the interface for generic multiplication services |
| multiplication | Concrete implementation of the multiplication service      |
| add-stub       | Provides the interface for generic addition services       |
| addition       | Concrete implementation of the addition service            |
| numbers        | Contains shared types used by various services             |
| calculator     | Provides a calculator service                              |

The dependency graph for this system looks as follows (packages point to their
dependencies):

    +---------------+     +---------------+     +----------------+
    | numbers       | <-- | mult-stub     | <-- | multiplication |
    +---------------+     +---------------+     +----------------+
           ^         <           ^
           |          \          |
    +---------------+  \  +---------------+
    | add-stub      |   \ | calculator    |
    +---------------+     +---------------+
           ^                     |
           |                     |
    +---------------+            |
    | addition      | <----------+
    +---------------+

## Stub Services

The stub services are rather simply, and contain only the interface definition
that they have. In this case the stubs also depend on another package, which
contains some shared types. (In this case it is obviously bad design, but
imagine that the types were more complex.) The entirety of the
mult-stub is:

    include "types.iol" from "numbers"

    interface IMultiplication {
    RequestResponse:
        multiply(TwoIntegers)(int)
    }

The other service (add-stub) is very similar.

## Implementation services

The implementation services contain the parameters and potentially ports with
missing input (which needs to be configured). When configuration is required,
we may also provide defaults that can be used as starting points.

The implementation of the two services are fairly similar, here are the
interesting parts of the multiplication service:

    include "console.iol"

    include "interfaces.iol" from "mult-stub"

    inputPort Multiplication {
        // Location and protocol is configurable by external configuration
        Interfaces: IMultiplication
    }

    parameters {
        maxInput: int
        minInput: int
        debug: bool
    }

    define CheckRequest { /* ... */ }

    main {
        [multiply(request)(total) {
            if (debug) { /* Stuff */ };
            CheckRequest;
            total = request.left * request.right
        }]
    }

The project structure of multiplication is as follows:

    .
    ├── conf
    │   ├── default.col
    │   └── production.col
    ├── include
    ├── lib
    ├── main.ol
    └── package.json

The include and lib folder works exactly as they do in the current version of
Jolie. We add another one of these folders, which is "conf". The conf folder is
supposed to hold default configuration units.

We don't have any "abstract" configuration units, but rather allow for all
units to be extended, if we happen to use a unit which doesn't contain all the
configuration required, we'll simply get an error. A single file may contain
multiple units if needed, or we could split them up. The contents of
default.col, for example:

    // multiplication/conf/default.col
    profile "default" configures "multiplication" {
        // Profiles don't have to provide all values
        maxInput = 100,
        minInput = 0
    }

    profile "development" configures "multiplication" extends "default" {
        // maxInput = 101, minInput = 0 from default profile
        maxInput = 101,
        debug = true,
        inputPort Multiplication {
            Location: "local"
            Protocol: sodep
        }
    }

The package manifest (package.json) of multiplication contains a dependency on
the stub:

    {
        "name": "multiplication",
        "description": "Multiplication implementation",
        "license": "MIT",
        "version": "1.0.0",
        "authors": "Dan Sebastian Thrane <dthrane@gmail.com>",
        "main": "main.ol",
        "dependencies": [
            { "name": "mult-stub", "version": "1.0.0" }
        ]
    }

## Implementation Details for Parameters

Translate each parameter assignment into a corresponding assignment in the init
block. If a block extends, then their assignments are performed first, allowing
them to be overriden later. Thus for the multiplication example above, it would
be roughly translated into:

    init {
        maxInput = 100;
        minInput = 0;
        maxInput = 101;
        debug = true

        // User defined init goes here
    }

Doing in this way also has benefits of allowing partial values to be defined.
If we want the parameters to persist we can assign them to a global scope, and
potentially create aliases to them for easier access. For example:

    init {
        global.params.maxInput = 100;
        // ...
        maxInput -> global.params.maxInput;
        // ...

        // User defined init goes here
    }

## Calculator Service

Assuming that the calculator service needs to embed the addition service, and
only externally bind to the multiplication service, we end up with the
following dependencies:

    {
        // ...
        "dependencies": [
            { "name": "numbers", "version": "1.0.0" },
            { "name": "mult-stub", "version": "1.0.0" },
            { "name": "addition", "version": "1.0.0" }
        ]
    }

As always, we need to create output ports to speak to the two services.

    include "interfaces.iol" from "add-stub.iol"
    include "interfaces.iol" from "mult-stub.iol"

    dynamic outputPort Multiplication {
        Protocol: sodep
        Interfaces: IMultiplication
    }

    outputPort Addition {
        Interfaces: IAddition
    }

It should be possible to configure, but not at runtime, both the protocol and
location of Addition. The Multiplication port, however, should not be
configurable externally, but fully at runtime. Thus in init, we may do:

    init {
        Multiplication.location = "socket://mul.example.com:42000"
    }

With the output ports setup, all there is left to do is configure them. Let's
first create a development profile, which embeds the addition service. Creating
a file called user.col:

    profile "development" configures "calculator" {
        inputPort Calculator {
            Protocol: "socket://localhost:42100"
            Protocol: sodep
        },

        outputPort Addition embeds "development"
    }

    profile "addition-for-dev" configures "addition" extends "development" {
        // Addition extends the "development" profile for "Addition"
        // This file is located in addition/conf/default.col
        allowOddInput = false
    }

No include is needed in the file, since all default units of a package is
automatically pulled into scope. All profiles are also namespaced under their
package. This is why both the addition and calculator service can have a
profile named "development" in the same scope.

The final structure of the calculator service may end up like:

    .
    ├── interfaces.iol
    ├── main.ol
    ├── package.json
    └── user.col

Before we can run the service, we must download our dependencies. This can be
done with the JPM CLI tool:

    $ jpm install
    ⬇️️ Downloading numbers 1.0.0
    ✔️ Completed numbers 1.0.0

    ⬇️️ Downloading add-stub 1.0.0
    ✔️ Completed add-stub 1.0.0

    ⬇️️ Downloading addition 1.0.0
    ✔️ Completed addition 1.0.0

    ⬇️️ Downloading mult-stub 1.0.0
    ✔️ Completed mult-stub 1.0.0

After this a new directory has been created which contains the source code of
each package:

    .
    ├── interfaces.iol
    ├── jpm_packages
    │   ├── addition
    │   ├── add-stub
    │   ├── mult-stub
    │   └── numbers
    ├── main.ol
    ├── package.json
    └── user.col

The package manager includes a utility for starting services. We can start the
service, optionally with a particular configuration profile:

    $ jpm start --conf development user.col

All this does is inspect the dependency tree of our service, and translate it
into the corresponding call to jolie. We could also have written:

    $ jolie \
        --pkg addition,jpm_packages/addition,main.ol    \
        --pkg add-stub,jpm_packages/add-stub            \
        --pkg numbers,jpm_packages/numbers              \
        --pkg mult-stub,jpm_packages/mult-stub          \
        --pkg calculator,.,main.ol                      \
        --conf development user.col                     \
        calculator.pkg

## Bonus: Putting a Proxy in-front of the Calculator

The desired deployment will look something along the lines of:

    +----------------+     +----------------+
    | proxy          | --> | calculator     |
    +----------------+     +----------------+

We'll implement the proxy using a courier, which will forward every single
request, but before doing so it will print a small message. The proxy service
itself will be entirely generic and only in its deployment will a reference be
made towards the calculator.

The proxy's manifest will be fairly simple, we don't need any dependencies:

    {
        "name": "proxy",
        "description": "A simple proxy",
        "license": "MIT",
        "version": "1.0.0",
        "authors": "Dan Sebastian Thrane <dthrane@gmail.com>",
        "main": "main.ol",
        "dependencies": []
    }

Similarly, the service implementation is going to be fairly simple. First we
define a dummy interface, which will represent the service we will proxy to:

    interface ITarget

And with that, we'll simply implement the logic like any other Jolie service:

    include "console.iol"

    execution { concurrent }

    interface ITarget

    outputPort Target {
        Interfaces: ITarget
    }

    inputPort Proxy {
        Location: "socket://localhost:12345"
        Protocol: sodep
        Aggregates: Target
    }

    courier Proxy {
        [interface ITarget(request)(response) {
            println@Console("Got a request!")();
            forward(request)(response)
        }]
    }

    main {
        // Whatever else we may be doing
    }

This should be enough to publish the package. We can now create a configuration
unit which correctly binds to the right interface.

    profile "calc-proxy" configures "proxy" {
        interface ITarget = ICalculator from "calculator",
        outputPort Target embeds "calculator"
    }

The JPM tool doesn't support directly starting these yet, but jolie could be
started directly with ease, simply by passing all the relevant --pkg and start
the proxy service.

