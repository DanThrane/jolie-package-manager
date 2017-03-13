# Introduction to JPM

JPM is a tool to facilitate both the development and sharing of Jolie
packages.

## Table of Contents


<!-- vim-markdown-toc GFM -->
* [Basic Usage](#basic-usage)
* [Publishing Packages](#publishing-packages)

<!-- vim-markdown-toc -->

## Basic Usage

A Jolie package corresponds to a single execution unit. Such an execution unit
might expose one or more services, and may in turn speak to several other
services.

We can use the [init](commands.md#init) command to create a new Jolie package:

```
$ ls
$ jpm init
Package name
------------
> foo

Package description
-------------------
> bar

Author: [Format: name <email> (homepage)]
-----------------------------------------
> Dan Sebastian Thrane <dthrane@gmail.com> (github.com/DanThrane)

Private package? [Y/n]
----------------------
> n

$ ls
foo
```

This command created a new package called "foo". Inside of the directory we
will find the [package manfiest](package_specification.md). This manifest
contains some basic information about the package, along with information
about its [dependencies](package_specification.md#dependencies), and which
[JPM registries](package_specification.md#registries) it talks to.

A JPM registry is a registry of known Jolie packages. A public registry exists
for packages, but private registries can be hosted. An organization might, for
example, host their own private repository for internal packages. JPM uses
these registries for pretty much any action. Many commands take an explicit
registry name, but if left out it will simply use the public JPM registry.

We can search for packages using the [search](commands.md#search) command:

```
$ jpm search calc
calculator@0.1.0/public MIT
  Demo service for JPM
```

We can add a dependency on this `calculator` service by adding it to the
[dependencies](package_specification.md#dependencies) section of the package
manifest. This will require us to add the following:

```json
{
    "dependencies": [
        { "name": "calculator", "version": "0.1.0" }
    ]
}
```

With this added to our package manifest, we can now install the dependency:

```
$ jpm install
Done
```

In our directory we will now find a new folder `jpm_packages`. This folder
contains the dependencies that our package has:

```
$ ls jpm_packages/
calculator
```

We can now write a client which uses this service, as if it were any other
service. Below we present a simple client:

```jolie
include "console.iol"
include "calculator" "calculator.iol"

outputPort Calculator {
    Interfaces: ICalculator
    Protocol: sodep
    Location: "socket://localhost:12345"
}

main {
    n[#n] = 1;
    n[#n] = 2;
    n[#n] = 3;
    req.n -> n;
    sum@Calculator(req)(total);
    println@Console(total)()
}
```

In line 2 we use a package include. The line reads as: "from the 'calculator'
package, include the file 'calculator.iol'. This automatically sets up the
correct include paths.

In order to run the client, we must first tell JPM which file serves as the
entry-point. We do this with the [main](package_specification.md#main)
attribute. Adding the following should do it:

```json
{
    "main": "client.ol"
}
```

Now assuming that the calculator service is already running, we can simply:

```
$ jpm run
6
```

## Publishing Packages

To publish a package we must first register an account with the registry
we wish to publish to.

To create an account we use the [register](commands.md#register) command.

```
$ jpm register
Username
--------
> Dan

Password
--------
> ****
```

This will securely save your credentials locally, such that you won't have to
authenticate everytime. You can check which account you're logged in as with
the [whoami](commands.md#whoami) command. You can also
[login](commands.md#login) and [logout](commands.md#logout).

```
$ jpm whoami
Dan
```

Publishing a package is a simple matter of using the
[publish](commands.md#publish) command. This will automatically give your user
the rights to publish updates. The same command can be used to publish updates,
however only people with the rights may do so.

```
$ jpm pulish
OK
```

