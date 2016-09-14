include "console.iol"
include "service_c/service_c_port.iol"
include "service_a/service_a_port.iol"

main {
    call@ServiceA(1)(res);
    call@ServiceC(1)(res2);
    println@Console(res)();
    println@Console(res2)()
}