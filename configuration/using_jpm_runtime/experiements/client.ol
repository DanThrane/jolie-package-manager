include "service_a.iol"
include "jpm_runtime_embed.iol"
include "console.iol"
include "string_utils.iol"

outputPort ServiceA {
    Interfaces: ServiceAIface
}

outputPort AltServiceA {
    Interfaces: ServiceAIface
}

main
{
    configure@JPMRuntime()(bindings);

    ServiceA << bindings.ServiceA;
    AltServiceA << bindings.AltServiceA;

    valueToPrettyString@StringUtils(bindings)(prettyBindings);
    println@Console(prettyBindings)();

    call@ServiceA(1)(res1);
    call@AltServiceA(1)(res2);

    println@Console(res1)();
    println@Console(res2)()
}
