# Nanoservices Anti-Pattern

How do we avoid this? How do we maximize re-usability, without fragmenting the
logic, which nanoservices typically do. An example of this would be the
lockfiles that JPM uses. I ended up moving them from their own package, into
an internal package.
