include "console.iol"

include "interfaces.iol" from "mult-stub"

execution { concurrent }

inputPort Multiplication {
    // Location and protocol is configurable by external configuration
    Interfaces: IMultiplication
}

parameters {
    maxInput: int
    minInput: int
    debug: bool
}

main {
    [multiply(request)(total) {
        if (debug) {
            println@Console("[multiply@Multiplication] left = " +
                    request.left + ", right = " + request.right)()
        };

        if (request.left < minInput || request.left > maxInput ||
                request.right < minInput || request.right > maxInput) {
            throw(MultiplicationFault)
        };

        total = request.left * request.right
    }]
}

