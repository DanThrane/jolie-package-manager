# Using a JPM Runtime

Let each client call some init function to JPM, which will take care of
configuring all output ports correctly. The problem we want to solve here, is
essentially to correctly pass output ports around. This sounds an awful lot like
dependency injection, and in many ways, it is the exact same problem.

For this reason lets attempt to adapt the conventions established in OOP for
dependency injection to also work with injecting services in Jolie.

With this approach we should let __all__ output ports be bound by JPM. Ideally
we would also have JPM assist in configuring the input ports, although that
might be a bit more complicated (we might still have to do constants for this).

Of course we cannot entirely control this, and if a package wants to circumvent
this, then it would still be possible. I do not believe we need to address this
further. If people want to write bad code they can, if they really need to
sidestep the system, they can.

## Guice Bindings (Summary)

Guice is a framework for dependency injection in Java. A binding in Guice
defines how to map a type to its concrete implementation. Much like how we in
Jolie will need to solve the problem of mapping a service interface to an output
port. This is a summary of the types of bindings Guice provides. For more
details see [guice detailed](guice_detailed.md).

  - Linked bindings deal with simple 1-to-1 mappings. The entire system will
    always use the same concrete implementation.
  - Binding annotations allows us to associate a name with a specific
    implementation. An the use-site we may state we want the concrete
    implementation denoted by a name.
  - Instance bindings allows us to associate a specific value (instance) to a
    name. Such as a string value or an integer value. This is essentially
    configuration.
  - Provides methods allows us to dynamically setup an instance, this may be
    bound to a name.
  - Provider classes are for more advanced cases
  - We may point to a default implementation or provider using `@ImplementedBy`
    and `@ProvidedBy`

