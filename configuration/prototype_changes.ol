// A.ol

ext outputPort A {
    Interfaces: AIface
}

ext outputPutPort B {
    Interfaces: BIface
}

constants {
    FOO: int
}

// A.col

include "B.col"
include "C.col"

// Previously called namespace. Configures makes it more explicit that we're 
// talking about a specific package and not an arbitrary name 
configures "A" { 
    // Like always we just put the definitions here
    FOO = 42

    // We alter the syntax slightly for output ports being embedded
    outputPort B embeds B 
    // The second B refers to the profile B (if no profile is specified it gets 
    // the same name as the package it configures). This means that this 
    // configures block also has name "A". It could also have been written as:
    // `profile "A" configures "A"`

    outputPort C embeds C
}

// B.col

configures "B" {
    inputPort B {
        Location: "local"
    }
}

// C.col

configures "C" {
    inputPort C {
        Location: "local"
    }
}

// In order to use an external B we need to update "A.col":

include "C.col"

configures "A" {
    outputPort B {
        Location: "socket://b.example.org:8000"
        Protocol: sodep
    }
    outputPort C embeds C
}

// In order to update the deployment file of B we simply need to update the 
// input port to no longer be local. In "B.col":

configures "B" {
    inputPort B {
        Location: "socket://localhost:8000"
        Protocol: sodep
    }
}

// In most cases however this would be unnecessary since the default 
// configuration file for "B" could already include a default input port.
// 
// In that case we could simply deploy directly from the default configuration!