# Namespaces

For the most part I think using C++ as an inspiration would make sense. Given
that C++, like Jolie, also uses file includes. As opposed to something like
Kotlin which solves this problem using packages. Where an import statement is
for the actual entity (e.g. a class) as opposed to the entire file. 

All entities will be placed under a namespace. You can place an entity directly
in a namespace using the following syntax:

```
interface This::Is::My::Namespace::FooIface {
    // ...
}
```

TODO Should this syntax even be supported or should it rely entirely on
namespace regions? For example using a colon is going to make parsing
complicated for type definitions (e.g. `type A::B::C::D::E:int`).

Or we could create a namespace region:

```
namespace This {
    namespace Is {
        namespace My {
            namespace Namespace {
                interface FooIface {
                    // ...
                }
            }
        }
    }
}
```

Or for that matter:

```
namespace This::Is::My::Namespace {
    interface FooIface {

    }
}
```

All definitions are implicitly placed under the global namespace. Thus if no
namespace is specified, it will automatically be placed under the global.

We may then use this interface in, for example, an output port:

```
outputPort Foo {
    Interfaces: This::Is::My::Namespace::FooIface
    Location: "auto"
    Protocol: sodep
}
```

It should also be possible to import the contents of a namespace, this can be
done using a `using` statement:

```
import "foo.iol"

using This::Is::My::Namespace

outputPort Foo {
    Interfaces: FooIface
    Location: "auto"
    Protocol: sodep
}
```

We may also include only some of the namespace we want, and then specify the
remaining. We can think of this as pulling parts of a namespace into the global
namespace:

```
import "foo.iol"

using This::Is::My

outputPort Foo {
    Interfaces: Namespace::FooIface
    Location: "auto"
    Protocol: sodep
}
```


Note that we still have to include the interface file. The following entities
can be put under namespaces:

  - interface
  - type
  - outputPort
  - inputPort
  - constants
