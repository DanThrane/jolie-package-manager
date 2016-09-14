// A dynamically configured output port for the calculator service.
// This file is "automatically" generated

// This cannot be imported multiple times. Which is rather problematic.
include "runtime.iol" 
include "service_a.iol"

constants {
    SERVICE_A_LOCATION = "socket://localhost:41001",
    SERVICE_A_PROTOCOL = "sodep"
}

outputPort ServiceA {
    Interfaces: ServiceAIface
}

init {
    if (SERVICE_A_LOCATION == "local") {
        loadEmbeddedService@Runtime({
            .filepath = "service_a.ol",
            .type = "jolie"
        })(Calculator.location)
    } else {
        Calculator.location = SERVICE_A_LOCATION;
        Calculator.protocol = SERVICE_A_PROTOCOL
    }
}
