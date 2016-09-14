include "service_a/service_a.iol"
include "service_b/service_b_port.iol"

execution { concurrent }

constants {
    SERVICE_A_LOCATION = "socket://localhost:41001",
    SERVICE_A_PROTOCOL = sodep
}

inputPort ServiceA {
    Location: SERVICE_A_LOCATION
    Protocol: SERVICE_A_PROTOCOL
    Interfaces: ServiceAIface
}

main
{
    [call(req)(res) {
        call@ServiceB(req)(res);
        res = res + 1
    }]
}
