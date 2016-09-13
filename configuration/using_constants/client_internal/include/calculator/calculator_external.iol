include "calculator/calculator.iol"

constants {
    CALCULATOR_LOCATION = "socket://localhost:41000",
    CALCULATOR_PROTOCOL = sodep
}

outputPort Calculator {
    Interfaces: CalculatorIface
    Location: CALCULATOR_LOCATION
    Protocol: CALCULATOR_PROTOCOL
}
