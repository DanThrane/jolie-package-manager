// A dynamically configured output port for the calculator service.
// This file is "automatically" generated

// This cannot be imported multiple times. Which is rather problematic.
include "runtime.iol" 
include "calculator.iol"

constants {
    CALCULATOR_LOCATION = "socket://localhost:41000",
    CALCULATOR_PROTOCOL = "sodep"
}

outputPort Calculator {
    Interfaces: CalculatorIface
}

init {
    if (CALCULATOR_LOCATION == "local") {
        loadEmbeddedService@Runtime({
            .filepath = "calculator.ol",
            .type = "jolie"
        })(Calculator.location)
    } else {
        Calculator.location = CALCULATOR_LOCATION;
        Calculator.protocol = CALCULATOR_PROTOCOL
    }
}
