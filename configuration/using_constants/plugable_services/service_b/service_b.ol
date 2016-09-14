include "service_b.iol"
include "service_c/service_c_port.iol"

execution { concurrent }

constants {
    SERIVCE_B_LOCATION = "socket://localhost:41002",
    SERIVCE_B_PROTOCOL = sodep
}

inputPort ServiceB {
    Location: SERIVCE_B_LOCATION
    Protocol: SERIVCE_B_PROTOCOL
    Interfaces: ServiceAIface
}

main
{
    [call(req)(res) {
        call@ServiceC(req)(res);
        res = res + 2
    }]
}
