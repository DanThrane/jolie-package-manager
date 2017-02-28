include "console.iol"

interface IFoo {
    RequestResponse:
        foo(void)(string)
}

outputPort Foo {
    Location: "socket://localhost:9999"
    Protocol: sodep
    Interfaces: IFoo
}

main {
    foo@Foo()(res);
    println@Console(res)()
}
