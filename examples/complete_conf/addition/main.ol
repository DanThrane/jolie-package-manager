include "console.iol"

include "interfaces.iol" from "add-stub"

execution { concurrent }

inputPort Addition {
    // Location and protocol is configurable by external configuration
    Interfaces: IAddition
}

parameters {
    allowOddInputs: bool
    debug: bool
}

main {
    [add(request)(total) {
        if (debug) {
            println@Console("[add@Addition] left = " +
                    request.left + ", right = " + request.right)()
        };

        if (!allowOddInputs) {
            if (request.left % 2 == 1 || request.right % 2 == 1) {
                throw(AdditionFault)
            }
        };

        total = request.left * request.right
    }]
}

