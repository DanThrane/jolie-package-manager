include "jpm_runtime.iol"

outputPort JPMRuntime {
    Interfaces: JPMRuntimeIface
}

embedded {
    Jolie:
        "jpm_runtime.ol" in JPMRuntime
}
