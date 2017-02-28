include "console.iol"

interface IDummy {
    RequestResponse: 
        foo(void)(void)
}

outputPort Foo {
    Interfaces: IDummy
}

constants {
    INTERNAL_CONSTANT: int
}

embedded {
    JoliePackage:
        "embedded" in Foo {
            inputPort Self { Location: "local" },
            DUMMY_CONSTANT republish as INTERNAL_CONSTANT
        }
}

main {
    println@Console("Calling foo in Foo...")();
    foo@Foo()()
}
