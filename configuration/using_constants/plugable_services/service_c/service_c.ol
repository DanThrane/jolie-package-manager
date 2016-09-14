include "service_c.iol"

execution { concurrent }

constants {
    SERVICE_C_LOCATION = "socket://localhost:41003",
    SERVICE_C_PROTOCOL = sodep
}

inputPort ServiceC {
    Location: SERVICE_C_LOCATION
    Protocol: SERVICE_C_PROTOCOL
    Interfaces: ServiceCIface
}

main
{
    [call(req)(res) {
        res = req + 3
    }]
}
