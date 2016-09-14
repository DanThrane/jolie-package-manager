// A dynamically configured output port for the ServiceB service.
// This file is "automatically" generated

// This cannot be imported multiple times. Which is rather problematic.
include "service_b/service_b.iol"
include "runtime.iol"

constants {
    SERVICE_B_LOCATION = "socket://localhost:41002",
    SERVICE_B_PROTOCOL = "sodep"
}

outputPort ServiceB {
    Interfaces: ServiceBIface
}

init {
    if (SERVICE_B_LOCATION == "local") {
        loadEmbeddedService@Runtime({
            .filepath = "service_b.ol",
            .type = "jolie"
        })(ServiceB.location)
    } else {
        ServiceB.location = SERVICE_B_LOCATION;
        ServiceB.protocol = SERVICE_B_PROTOCOL
    }
}
