# Changes to Include Statements

Any package we depend on we will inheriently need to include it. This might mean
that we have to include simply the definition (interfaces and types), or we
might have to include a definition which will embed the service. Nevertheless we
must ensure that the correct files are found. This must remain consistent
between both the development of the package and after the service has been
packaged and used as a dependency.

There are roughly two ways we may go around actually packaging our packages.
These are flat files and jap files.

## Jap Files

The current syntax for including a service is rather verbose, for example:

```
include "jar:file:./git.jap!include/embed.iol"
```

Instead of:

```
include "git/embed.iol"
```

### Issues

  1. Incorrect search path when embedding a Jolie service within a JAP file. The
     EmbeddedJolieServiceLoader will attempt to load files from the file system,
     as opposed to within the JAP file.
  2. Expanding on #1. Removing the output port and linking directly to the JAP
     resource works, however the includes from within the `.ol` implementation
     fails to find the interface file within the JAP file. Again it attempts to
     search the file system, as opposed to the JAP file.
  3. The include path convention and the class path convention is broken when
     including from JAP files. This means that the `lib` and `include` folders
     are completely ignored from within a JAP file. This means that we cannot
     package directly on top of this.
  4. Reading file resources from within a JAP file does not work. This could
     give some problems if a service, for example, decides to pull default
     configuration from a file. This would fail since it will be unable to find
     the default file, even though it is located in the JAP file.

Regarding issue #1 and #2 gives similar stack-traces which output what is most
likely the current directory. It looks like this: 

```
/home/dan/projects/master_thesis/thoughts/jap_jolie_include/usage/jar:file:./foobar.jap!/foobar.ol
```

Which of course is nonsense path, but this is probably a good hint as to what is
wrong.

## Flat Files

We should be able to avoid name-clashes if we put every tarball into their own
directory. However this proves problematic due to the fact that inlcudes are
done relative to the current working directory, as opposed to in C++ where
includes are done relative to the file which has the include.

This becomes a problem since all includes would have to be changed if we extract
a package into a new folder, which exists in a different place, to where you
would start the interpreter.

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

The client should then be able to include the services `a` and `b` in the
following way:

```
include "service_a/default_port.iol"
include "service_c/default_port.iol"
```

# Overall Issues with Include Statements

  1. Including a file twice may cause problems in some cases, while in others it
     won't cause problems. This for example occurs if an include file causes
     embedding of a service

# Propsed Changes to Include Statements

  1. Make includes relative to the source file which contain the include
     (BREAKING CHANGE)
  2. Automatically add an include guard, which ensures that the contents of an
     include file is only included once. (BREAKING CHANGE)
  3. Change the search algorithm to always follow the convention of the include
     directory and lib directory (Although this is in a different place)
