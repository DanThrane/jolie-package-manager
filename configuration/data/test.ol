include "console.iol"

constants {
    A = asd
}

main {
    scope (A) {
        println@Console("Hello, world!")()
    }
}