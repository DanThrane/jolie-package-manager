include "jpm_runtime.iol"
include "runtime.iol"
include "console.iol"

execution { concurrent }

inputPort JPMRuntime {
    Location: "local"
    Interfaces: JPMRuntimeIface
}

main
{
    [configure(req)(bindings) {
        println@Console("Started configuration of project")();
        loadEmbeddedService@Runtime({
            .filepath = "service_a.ol",
            .type = "jolie"
        })(bindings.ServiceA.location);
        
        bindings.AltServiceA.location = "socket://localhost:41001";
        bindings.AltServiceA.protocol = "sodep";
        println@Console("Finished configuring project")()
    }]
}
