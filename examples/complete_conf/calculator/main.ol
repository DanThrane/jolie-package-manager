include "interfaces.iol"

include "interfaces.iol" from "add-stub.iol"
include "interfaces.iol" from "mult-stub.iol"

execution { concurrent }

inputPort Calculator {
    Protocol: sodep
    Interfaces: ICalculator
}

dynamic outputPort Multiplication {
    Protocol: sodep
    Interfaces: IMultiplication
}

outputPort Addition {
    Interfaces: IAddition
}

init {
    // we can do this since "Multiplication" is dynamic
    Multiplication.location = "socket://mul.example.com:42001"
}

main {
    [sum(request)(total) {
        total = request.numbers[0];
        for (i = 1, i < #request.numbers, i++) {
            add@Addition({
                .left = total,
                .right = request.numbers[i]
            })(total)
        }
    }]

    [product(request)(total) {
        total = request.numbers[0];
        for (i = 1, i < #request.numbers, i++) {
            multiply@Multiplication({
                .left = total,
                .right = request.numbers[i]
            })(total)
        }
    }]
}

