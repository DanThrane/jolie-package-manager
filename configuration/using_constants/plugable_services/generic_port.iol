// A dynamically configured output port for the calculator service.
// This file is "automatically" generated

// This cannot be imported multiple times. Which is rather problematic.
include "runtime.iol" 
include "FILE_NAME.iol"

constants {
    SERVICE_NAME_LOCATION = "socket://localhost:SERVICE_PORT",
    SERVICE_NAME_PROTOCOL = "SERVICE_PROTOCOL"
}

outputPort PORT_NAME {
    Interfaces: PORT_NAMEIface
}

init {
    if (SERVICE_NAME_LOCATION == "local") {
        loadEmbeddedService@Runtime({
            .filepath = "FILE_NAME.ol",
            .type = "jolie"
        })(Calculator.location)
    } else {
        Calculator.location = SERVICE_NAME_LOCATION;
        Calculator.protocol = SERVICE_NAME_PROTOCOL
    }
}
