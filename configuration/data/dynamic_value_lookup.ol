include "console.iol"

main {
    a = args[0];
    b = 10;
    c = 42;
    d = 50;

    dynamic = global.a;
    println@Console(dynamic)()
}