/*
 * In the circuit breaker service
 */

// This is not interface inheritance! This is simply a hint to the type-checker
// that this interface must remain compliant with BaseIface. What this means is
// that if an operation is missing from an interface "extending" BaseIface then
// those won't be added automatically, instead this would trigger an error
// since it is no longer compliant.
ext interface TargetIface : BaseIface 

// The circuit breaker doesn't rely on any specific operations to be present.
// Because of that the implementation is empty.
interface BaseIface { } 

ext outputPort TargetSrv {
    // We don't want to make the "Interfaces" field external. This would give us
    // way too many problems
    Interfaces: TargetIface
}

interface extender CBIfaceExt {
    RequestResponse:
        *( void )( void ) throws CBFault
}

ext inputPort CircuitBreaker {
    Interfaces: CBIfaceExt
    Aggregates: TargetSrv with CBIfaceExt
}

courier CircuitBreaker {
    [ interface TargetIface( request )( response )] {
        // ...
    }

    // If the courier were to use an operation which is not available in
    // BaseIface then it should complain with an error, since that operation
    // cannot be guaranteed to exist in the end.
}

// ============================================================================

/*
 * In the target service
 */

// Since the base interface is empty there is not much need to hint that we need
// to remain compliant, but we could do this. This shouldn't create a cyclic
// dependency, since it is the target service that depend on the circuit breaker
// and not the other way.

interface MyInterface { 
    RequestResponse: // This is an ordinary interface definition
        foo( void )( void ) 
}

// ============================================================================

/*
 * In the deployment. 
 * 
 * This will either be in the package of the target service
 * (depending only on the circuit breaker) or in a separate package (this would
 * depend on both the target service and the circuit breaker)
 */

configures "circuit_breaker" {
    // We only allow _references_ to existing interfaces. This interface must be
    // concrete. The syntax of this configuration construct is: 
    // "interface" ID(InterfaceName) "=" ID(PackageName) "::" ID(InterfaceName)
    //
    // We don't need to connect this to a specific deployment since the
    // interface cannot be changed by the deployment of the package
    interface TargetIface = target::MyInterface,
    // We are able to extract only the interface and the needed types from a
    // package. This is done using the following steps:
    //
    //   1. Parse the program at the entry point defined by the package.
    //   2. Extract from the interfaces the desired interface
    //   3. Extract the associated type definitions
    //   4. (These should probably be cloned such that we can GC the 
    //       otherwise fully parsed program) 
    //   5. Include these in the program, as if they had been included

    outputPort TargetSrv {
        Location: "socket://target.example.org:12345"
        Protocol: sodep
    }
}
