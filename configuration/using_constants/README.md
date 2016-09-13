# Example - JPM Configuration via Constants

This example shows how JPM can be used to pass constants to Jolie which will be
used for configuration purposes. Most importantly this propsoal shows what is
possible to do, without having to change how the language works.

In the example is included a small client, and a calculator service. The client
itself depends on the calculator service, and using configuration passed in
`package.json` it can specify if the calculator service should be internal or
external.

Included in this example we have:

  - `calculator`: The calculator service
  - `client_internal`: A simple client using an internal calculator
  - `client_external`: A simple client using an external calculator

Included is also a small python script named `jpm`. This tool will read the
`package.json` and will then invoke the Jolie interpreter with the relevant
command line arguments. For example, running `jpm start` inside the
`client_internal` directory will cause the following command to be invoked:

```
jolie -C CALCULATOR_LOCATION=\"local\" client.ol
```

The constants being passed to the interpreter are read from the `constants`
property and the main file read from the `main` property.

Inside of the two client examples, there will be some files that come from the
calculator service. These are placed here simply to make the demo work. These
files should be considered hidden from the perspective of the client developer.
For this reason we also won't be able to use any solution which requires us to
change the source code of a package we depend on (that is without forking that
package).

The README files of each folder will show how these can be run. These also
contains additional discussion of the details of each package.
