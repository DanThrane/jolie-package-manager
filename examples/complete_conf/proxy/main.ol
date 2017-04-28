include "console.iol"

execution { concurrent }

interface ITarget

outputPort Target {
    Interfaces: ITarget
}

inputPort Proxy {
    Location: "socket://localhost:12345"
    Protocol: sodep
    Aggregates: Target
}

courier Proxy {
    [interface ITarget(request)(response) {
        println@Console("Got a request!")();
        forward(request)(response)
    }]
}

main {
    // Whatever else we may be doing
}

