# Use-cases

  1. Add types to each other
    + Used in couriers for extending types in operations
  2. Subtract types from each other
    + Partially used but only in values for cutting values before forwarding in 
      couriers
    + Could be used for providing values before forwarding (e.g. used for 
      simplifying the interface of another service)
  3. Add interface to interface
    + Provide several interfaces (Used in ports)
  4. Remove interface from interface
    + Hide operations (Currently not done, but useful for proxy services)

# Current Behavior

# Problems we solve and replace with this
 
  - jolie2surface
  - Multiple interfaces in ports (replace with one) [Why would we?]
  - interface extender [Why would we?]
  - Generic services (Does this include types?)
  - Redirects?

# Core Goal

Change the way ports and their interfaces are used such that it becomes possible
to create more generic packages. With this we would also like a better interface
for dealing with this, such that (for example) subinterface checks become
possible for arbitary interfaces.

This will require refactoring and changes to the following components:

  - Interfaces
  - Types
  - Couriers
  - Configuration
  - Ports

# Proposed Syntax

# Problems

At the core it would appear that we're trying to solve the following problem.
Given a Jolie service in two different versions, check if the newer version is
backwards compatible with the older version. The way that we discussed this, it
sounded like we were going to implement this by simply comparing the interfaces.

But simply comparing the interfaces, even if we factor in aggregates, won't be
enough. Since these do not actually represent the exposed interface at the
network level. To do this we must also factor in the protocol and location (as
these can also change the protocol) of the input ports. Thus it seems logical
that we would like to compare the exposed interface between two versions to
check if they are compatible. However once we include protocols in this
procedure we run into a few problems:

  The protocol configuration is implemented as code, thus we need to execute
  it to get the values

This we could probably deal with, if it wasn't for the next fact that:

  The presence of aliases in configurations means that the exposed interface
  may change during execution.

These issues are nicely illustrated in the HTTP protocol, where we have several
issues. For example operation-specific aliases directly change the exposed
interface. The use of a default operation is also a huge problem, since we may
do our own routing to other operations. In that case the entire exposed
interface could be defined in that single default operation. This also appears
to be what you are doing for the Jester tool.