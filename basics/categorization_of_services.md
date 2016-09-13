# Types of Services

## Embedded Services (Libraries)

This is the type of the service which doesn't make sense to host on an external
VM. The intent of these services is to execute some kind of work directly on the
machine. These services differ from the hybrids in that their work only really
makes sense to execute locally. 

## Services w/Semi-Fixed Output Ports

These types of services are most likely closed source. The packages would
include only the output ports, interfaces and any relevant types. These packages
wouldn't be available for self-hosting, and for that reason the output ports
would mostly remain static. 

An example of this could for example be the GitHub API. Depending on the
service, there might be cases where this output port could change slightly, for
example the service might expose the same API but for different regions. An
Amazon service could provide the same API for their different sites (i.e.
`amazon.co.uk`, `amazon.com`, `amazon.de`, etc.)

## "Hybrids"

This would probably include most ordinary services written in Jolie. These
services are intended to run on any VM, it could be internal or it could be
external. The package would include both the implementation, but also the
description (i.e. interfaces + types).

# Dealing with External Services

For the time being I'd like to see if we can solve the problems associated with
these types of services solely through package conventions, and the tools we
already have at our disposal. 

For example configuring which region to use, should be the responsibility of the
package. Using the tools available to use at the moment, we can solve this in
one of two ways:

  1. Use constants in the output port
  2. Use dynamic binding

Dynamic binding should work just like before. 

Constants however would have to be passed in from the command line to the Jolie
interpreter. This might make development a bit cumbersome. For this reason I
propose that the `package.json` file should be allowed to contain constants,
which it will automatically pass to the interpreter.

```json
{
    "main": "main.ol",
    "constants": {
        "MY_SERVICE": {
            "REGION": "EU"
        }
    }
}
```

This would tell the package manager that the main file is called `main.ol` and
that once `jpm start` is called, it should invoke that file. This would also
expose a constant under the name `MY_SERVICE_REGION` with the value `"EU"`.

Using this I have extended the calculator example to show how this could work.
The calculator now has a new file `calculator_external.iol`. This file sets-up a
default output port, which can be overwritten with constants passed via the
configuration. This is shown in the `client_example` folder. The relevant part
being: 

```json
{
    "main": "client.ol",
    "constants": {
        "CALCULATOR": {
            "LOCATION": "socket://localhost:8000",
            "PROTOCOL": "sodep"
        }
    }
}
```

The code for the embedded case remains mostly unchanged. Except that we have to
instruct the calculator to use a local input port. 

In the case that we need more control over which service to use. We can always
resort to setting up the output port manually, as shown in `client_manual`. In
the case of a service registry, I would imagine that this would be implemented
as a separate project. 