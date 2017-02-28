# External Constants

TODO:

  - Figure out and document how variables currently work
    + How do we look them up? Can we put constants in a separated scope that
      can still be found in code?
    + Can we make some variables read only? This should work even for stuff
      like arrays (probably not that big of a problem in Jolie)
    + How do we enforce the type checking on these? 
  - We need to make sure things work on the .ol and .col side of things 

---

Variables are parsed into a `VariableExpressionNode` and are evaluated from
that.

Variables do have a type, which would be ideal for us to tag the constants type
on. However this won't work for several reasons. Most importantly we want to
remain backwards compatiable, the other types require a prefix, we don't want a
prefix. Thus we need to be in the same scope.

A working strategy would be to:

  - Check if .col and .ol works 
  - Use ordinary `VariablePath`s
  - When a variable path evaluates, it will return a `Value`. We need to tag
    this value as being constant. This way when we attempt to assign using
    `Value#assignValue` we can crash at run-time. Don't think this is possible
    from a Jolie program, but we might be able to from outside. Either way
    crashing is the right thing to do, and we should do it.
  - We should still be able to look up constants dynamically (actually this is
    new, but for trees this would be useful)
  - Detect assignment nodes that work with static root paths that are constants
    (OOITBuilder probably)
  - Turn off old constant parsing code
  - Translate old constants to values in their correct variable paths
  - Allow internal trees
  - There are places that only allow simple constants. We need to make sure 
    that we handle these edge-cases.

We do not allow constants on the right side of pointer assignment. This way we
could manipulate links indirectly. Here we have several difficult problems, that
can create unintuitive rules. Dynamic paths:

```jolie
constants { A: int }

main { link.(args[0]) -> A; }
```

Here we cannot statically evaluate where the link is stored, and thus not be
able to statically verify we aren't using it. We could resolve this by not
allowing a dynamic path on the left side if the right side is a constant.
However we would still have problems with indirect paths and redefinitions of a
path. For example:

```jolie
constants { A: int }

/**
 * @input anotherLink
 */
define UtilityThing {
  // Do something with anotherLink
}

main {
  link -> A;
  myNonConstantValue = 10;
  anotherLink -> myNonConstantValue;
  UtilityThing;
  anotherLink -> link; // We should register anotherLink as pointing to a constant
  UtilityThing; // If UtilityThing mutates it we shouldn't allow this
  // At this point we might redefine anotherLink to point elsewhere. 
  // It will be hard to determine at any point if anotherLink is pointing to a 
  // constant or something else once we mix in control flow.
}
```

In Jolie constants can be identifiers. This obviously doesn't fit the constants
are values paradigm. For this we keep a small part of the old system which
parses an identifier in the constants and uses it. I really don't like this
system, but we can keep it in.

We support protocol constants through the old identifiers and ext ports.

Moved protocol check for input ports to `OOITBuilder` because of externally
bindable locations occur later.