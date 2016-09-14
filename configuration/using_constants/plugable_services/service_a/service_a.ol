include "service_a.iol"
include "service_b/service_b_port.iol"

execution { concurrent }

constants {
    SERIVCE_A_LOCATION = "socket://localhost:41001",
    SERIVCE_A_PROTOCOL = sodep
}

inputPort ServiceA {
    Location: SERIVCE_A_LOCATION
    Protocol: SERIVCE_A_PROTOCOL
    Interfaces: ServiceAIface
}

main
{
    [call(req)(res) {
        call@ServiceB(req)(res);
        res = res + 1
    }]
}
