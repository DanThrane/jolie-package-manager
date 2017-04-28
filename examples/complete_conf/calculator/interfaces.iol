include "types.iol" from "numbers"

interface ICalculator {
    RequestResponse:
        sum(IntegerSequence)(int),
        product(IntegerSequence)(int)
}
