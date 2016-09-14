# Calculator Service

## About this Demo

The calculator exposes a single service. This service contains a very simple
`sum` operation.

The demo contains the following files:

  - `package.json`: Contains a package description. This includes the main file.
  - `calculator.ol`: The main file which starts the service. 
  - `include`
    + `calculator.iol`: Contains interface and types.
    + `calculator_port.iol`: (Potential) Automatically generated file for 
      a default output port dynamically configured from configuration

Inside of the `calculator.ol` file is the input-port. This port is configured
via constants in the following way:

```
constants {
    CALCULATOR_LOCATION = "socket://localhost:41000",
    CALCULATOR_PROTOCOL = sodep
}

inputPort Calculator {
    Interfaces: CalculatorIface
    Location: CALCULATOR_LOCATION
    Protocol: CALCULATOR_PROTOCOL
}
```

This setup allows us to do the following things:

  - Define a default location and protocol via the constants in the source code
  - The default location and protocol allows us to generate defaults for the
    `calculator_port.iol`

If we need to do any additional configuration, we can still do so using the
constants passed through the `package.json` file. This could for example be done
in the `init` section.

### Potential Problems

  - This requires the developer to write in boiler-plate code for the input-port
  - The use of simple constants is potentially a fragile system. Since the only
    system that would look at these constants would be a system that
    automatically generates the remaining files. Ideally we would generate the
    input-port as well. Although I don't believe this is possible with the
    current approach.
  - ~~Switching between internal and external use requires several changes.
    First all include sites must change the file. Secondly the configuration
    file must be updated to include new location and protocol constants.~~

## Running the Demo

From this directory run:

```bash
../../jpm start
```

This will launch the calculator service on the default port (41000).
