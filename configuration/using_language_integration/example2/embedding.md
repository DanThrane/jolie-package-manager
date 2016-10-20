# Embedding in Large Dependency Trees

Moving back and forth between internal and external use of a service may seem
trivial. In the simplest case we may have:

![](structure.png)

In this case it is clear that A should be able to dictate where each of the
dependencies are located, and if any of them are internal. However this becomes
more complicated as the dependency tree grows.

![](structure2.png)

In this case we have a new client which embeds a service, which has several
dependencies. The client however only needs to list the service S, and it only
ever communicates with S.

__Should we allow the client to configure the ports of S' dependencies?__

If we 