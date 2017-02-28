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
    outputPort DBB embeds DBA
}

// DBA.col
profile "DBA" configures "Database" {
    outputPort A {
        // Externally deployed (and configured) instance
    }

    outputPort B {
        Location: "socket://shared.example.org:41000"
        Protocol: sodep
    }
}

// DBB.col
profile "DBB" configures "Database" {
    outputPort A {
        // Externally deployed (and configured) instance
    }

    outputPort B {
        Location: "socket://shared.example.org:41000"
        Protocol: sodep
    }
}
