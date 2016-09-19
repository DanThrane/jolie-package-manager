include "service_a.iol"
include "console.iol"

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
        println@Console("Running service a logic")();
        res = req + 1
    }]
}
