# Flat Files

We should be able to avoid name-clashes if we put every tarball into their own
directory. 

Consider a package, which has the following dependency tree:

![](dependency_tree.png)

This should cause the following directory structure:

  - `include`
  - `lib`
  - `client.ol`
  - `jpm_packages`
    + `service_a`
      - `include`
        + `default_port.iol`
      - `lib`
      - `service_a.ol`
    + `service_b`
      - `include`
        + `default_port.iol`
      - `lib`
      - `service_b.ol`
    + `service_c`
      - `include`
        + `default_port.iol`
      - `lib`
      - `service_c.ol`
