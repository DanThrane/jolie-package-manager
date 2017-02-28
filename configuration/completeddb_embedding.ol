// Client.ol
ext outputPort DBA {
    Interfaces: DatabaseIface
}

ext outputPort DBB {
    Interfaces: DatabaseIface
}

// Database.ol
ext outputPort A {}
ext outputPort B {}

// Client.col
include "DBA.col"
include "DBB.col"

configures "Client" {
    outputPort DBA embeds DBA
    outputPort DBB embeds DBB
}

// DBA.col
include "DBA_A.col"

profile "DBA" configures "Database" {
    inputPort Database {
        Location: "local"
    }

    outputPort A emebds DBA_A

    outputPort B {
        Location: "socket://shared.example.org:41000"
        Protocol: sodep
    }
}

// DBB.col
include "DBB_A.col"

profile "DBB" configures "Database" {
    inputPort Database {
        Location: "local"
    }

    outputPort A embeds DBB_A

    outputPort B {
        Location: "socket://shared.example.org:41000"
        Protocol: sodep
    }
}

// DBA_A.col
include "C.col"
include "D.col"

profile "DBA_A" configures "A" {
    inputPort A {
        Location: "local"
    }

    outputPort C embeds C
    outputPort D embeds D
}

// C.col
profile "C" configures "C" { // Can also be written as just: configures "C"
    inputPort C {
        Location: "local"
    }
}

// D.col
configures "D" {
    // We might want a short hand for embedding with something like this
    // But for this we need to know which output port that needs to be changed.
    inputPort D {
        Location: "local"
    }
}

// DBB_A.col
include "C.col"

profile "DBB_A" configures "A" {
    inputPort A {
        Location: "local"
    }

    // We can share the configuration unit since they are the same
    outputPort C embeds C 

    outputPort D {
        // Something external
    }
}
