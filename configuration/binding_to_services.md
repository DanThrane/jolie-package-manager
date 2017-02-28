# Binding to Services

__Proposal:__ Extend the language wrt. what goes in the `Interfaces`. This would
mean that we could create interfaces based on other stuff. For example we could
describe that we want an interface added with some extender:

```jolie
ext outputPort CBToMyPort {
    Interfaces: IMyPort with CBExtender
}
```

We could extend that to include matching the input port of a known service:

```jolie
ext outputPort MyServicePort {
    Interfaces: MyServiceInputPort in "my-service"
}
```

This sort of thing would require us to pass a configuration unit. Otherwise we
won't be able to fully resolve the interface

```jolie
ext outputPort MyServicePort {
    Interfaces: MyServiceInputPort in "my-service" {
        // ...
    }
}
```

This is made more complicated if the service does multiple levels of this
parametric interface stuff. Not sure if this would actually be a problem? Would
we need to be able to pass more than one config unit? This is somewhat needed
elsewhere too. See [inline configuration units](inline_config.md).

__What about redirection?__

We have perfect knowledge of them, even what each resource should point to.
However since this is part of the Location attribute this is weird. Maybe we
just extend the previous?

```jolie
ext outputPort MyServicePort {
    Interfaces: MyServiceInputPort of resourceIdentifier in "my-service" {
        // ...
    }
}
```

I feel fairly confident that this is truly a trivial problem. The only big
obstacle should be integrating it into the code-base