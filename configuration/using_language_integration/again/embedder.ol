// A.ol

ext inputPort A {}

constants {
    A_CONSTANT: int,
    B_CONSTANT: int
}

ext outputPort C { /* ... */ }

outputPort B { // Since B is being embedded in-source it cannot be "ext"
    Interfaces: BIface
}

embedded {
    Jolie:
        "b.ol" in B {
            // This is essentially republishing the same configuration that 
            // B exposes. The syntax is: 
            // <construct in embeddee> republish as <construct in embedder>
            B_CONSTANT republish as B_CONSTANT

            inputPort B {
                Location: "local"
            }
        }
}

// D.ol

ext inputPort D {}

constants {
    D_CONSTANT: int
}

// E.ol
ext outputPort C
outputPort A {}
outputPort D {}

embedded {
    Jolie:
        "a.ol" in A {
            // This allows us to provide a complete configuration unit, in the 
            // almost same syntax as the external files (we don't need the 
            // wrapper since we're just passing the contents). The syntax won't 
            // be the exact same since external files can't republish
            inputPort A {
                Location: "local"
            }

            A_CONSTANT = 42
            B_CONSTANT = 300

            outputPort C republish as C
        },
        "d.ol" in D {
            inputPort D {
                Location: "local"
            }

            D_CONSTANT = 1000
        }
}
