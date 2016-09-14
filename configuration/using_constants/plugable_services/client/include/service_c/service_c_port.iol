// A dynamically configured output port for the service_c service.
// This file is "automatically" generated

// This cannot be imported multiple times. Which is rather problematic.
include "runtime.iol" 
include "service_c/service_c.iol"

constants {
    SERVICE_C_LOCATION = "socket://localhost:41003",
    SERVICE_C_PROTOCOL = "sodep"
}

outputPort ServiceC {
    Interfaces: ServiceCIface
}

init {
    if (SERVICE_C_LOCATION == "local") {
        loadEmbeddedService@Runtime({
            .filepath = "service_c.ol",
            .type = "jolie"
        })(ServiceC.location)
    } else {
        ServiceC.location = SERVICE_C_LOCATION;
        ServiceC.protocol = SERVICE_C_PROTOCOL
    }
}
