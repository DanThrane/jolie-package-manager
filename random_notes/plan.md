# Implementation Plan

Several patches are required to make Jolie ready for packages. The
implementation plan is as follows.

## Package Includes

Implement package includes. These use the following syntax:

```jolie
include "<pkgName>" "<fileName>"
```

These will work just like the ordinary include statement, except that it will
include files from a package. Thus the above statement will include files from:
`<packageFolder>/<pkgName>/[include]/<fileName>`. Note that we keep the implicit
include semantics.

The folder `<packageFolder>` can be specified to the interpreter using a command
line argument: `--pkg-folder <packageFolder>`. This folder will be relative to
the current working directory. (Note: I am open to this defaulting to the folder
used by JPM, however I don't want any more coupling between these projects)

This feature is needed, such that we may easily include a file from a different
package. Files from within a package must then be able to include files as it
would ordinarily, these should be pulled from the sources we would expect local
to the package. It should also be able to include from other packages.

This feature must also ensure that libraries are automatically added from
packages. Currently files from the `lib` folder is automatically added to the
classpath. Files placed within a package's `./lib` should also be added
automatically.

Finally this patch must take care of Jolie services being embedded from within a
package. The correct search paths must be used, and the new interpreter instance
must have the appropriate include paths added.

## Configuration (for Ports)

This patch will include:

  - Parsing of `.col` files
  - Basic verification and evaluation of `.col` files
  - New keywords for allowing external constructs (for now only enabled for
    input and output ports)
  - Implement external configuration of ports using `.col` files
  - This will add the following new command line arguments:
    + `--deploy <configFile> <profileName>`: Describes that we should be
      deploying from external configuration. The configuration tree can be
      created by loading `<configFile>`. Within this tree the profile
      `<profileName>` should be used.
    + `--main.<packageName> <filePath>`: Defines the main entry point for the
      package `<packageName>`. This is used for resolving the `.ol` file to
      load.

## Configuration for Statically Embedded Jolie Services

This patch will include:

  - Changes to the `.ol` parser. This will introduce configuration regions for
    Jolie's embedded services
  - Introduce the `republish` keyword required for republishing configuration

## Constants and Configuration for Constants

This patch will include:

  - Rewrite of constants, such that they will now allow for generic values
  - Enable `ext` constants in `.ol` files
  - Enable constants in `.col` files

## Namespaces

...