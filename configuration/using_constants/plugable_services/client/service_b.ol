include "service_b/service_b.iol"
include "service_c/service_c_port.iol"

execution { concurrent }

constants {
    SERVICE_B_LOCATION = "socket://localhost:41002",
    SERVICE_B_PROTOCOL = sodep
}

inputPort ServiceB {
    Location: SERVICE_B_LOCATION
    Protocol: SERVICE_B_PROTOCOL
    Interfaces: ServiceBIface
}

main
{
    [call(req)(res) {
        call@ServiceC(req)(res);
        res = res + 2
    }]
}
