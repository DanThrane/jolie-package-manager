Enforcing semantic versioning requires us to compare the public API of two
versions of the same service. To do this means that we must have knowledge of
the publicly exposed API.

Which parts of the exposed API is public? That usually depends on the developer,
but there is nothing stopping us from defining what should be considered public,
and what shouldn't be considered public.

What is the exposed API? This corresponds to the messages that we may send to
the service, that it will respond to. Each type of message must have a well-
defined structure, along with a well-defined response. Thus the exposed API
depends on the messages sent to it, which means that we depend on the protocol
of the service.

The protocol of a service also depends on the location, as it might implicitly
override the protocol.

Technically the exposed API even depends on the choregraphy of the service. The
problem here becomes that the public API at a certain point depends on state. We
cannot determine this beforehand.

Being able to switch between protocols brings up some additional questions as
well. For example code that is considered to be the same under one protocol
could be considered a major breaking change in another. Consider the following
type:

```jolie
type A: void {
    .b: String
    .c: int
}
```

In the following version of the same service we change the order of `b` and `c`.

```jolie
type A: void {
    .c: int
    .b: String
}
```

Under a protocol like HTTP this would be considered equal types, under a
protocol like sodep this should be considered a breaking change. The reason is
that a protocol like HTTP doesn't use the order of subfields for anything, while
under sodep the order determines how the type is serialized. 

> The public API of a Jolie service is not statically defined

  - The protocol of a Jolie service can partially determine the public API of a
    service
  - The protocol of a Jolie service is not statically defined
