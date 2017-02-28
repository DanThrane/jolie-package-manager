include "console.iol"

interface IDummy {
    RequestResponse: 
        foo(void)(void)
}

ext inputPort Self {
    Interfaces: IDummy
}

constants {
    DUMMY_CONSTANT: int
}

main {
    [foo()() {
        println@Console("The value of DUMMY_CONSTANT is:")();
        println@Console(DUMMY_CONSTANT)()
    }]
}