# Changes to Include Statements

Any package we depend on we will inheriently need to include it. This might mean
that we have to include simply the definition (interfaces and types), or we
might have to include a definition which will embed the service. Nevertheless we
must ensure that the correct files are found. This must remain consistent
between both the development of the package and after the service has been
packaged and used as a dependency.

There are roughly two ways we may go around actually packaging our packages.
These are [flat files](flat_files.md) and [jap files](jap_files.md). These two
documents cover some initial problems and potential implementation strategies.

# Issues and Proposed Changes

## Repeated Includes

__Problem:__ For the most part duplicate includes are allowed in Jolie, and will
have no effect. This is the case when an include file only contains types and
interfaces. However in the case of include files which contains embeddings, this
won't be the case. Instead the code will crash, since the embedding will already
have occured once.

__Proposed changes:__ Automatically add an include guard, which ensures that the
contents of an include file is only included once. This change is technically
breaking, although it is unlikely to break much code.

## Syntax for Including Packages

__Problem:__ The syntax for including a package should be relatively simple,
while at the same time not being confusing. Developers are currently used to the
include path being injected at the start of the string in the following
way: `include "$SEARCH_PATH/$FILE"`. For packages this however becomes more
complicated. Take for example the case of
[flat files](flat_files.md). We would have to inject the search path in several
places. We might for example like the statement `include "service_a/file.iol"`
to include a file placed at `jpm_packages/service_a/include/file.iol`, this
would mean that we inject into the path in several places, and not just at as a
prefix.

__Proposed changes:__ For this reason I propose a separate syntax for including
packages. I have included a few options, most of these only differ in syntax. I
would personally prefer option 3 or 4, or some other syntactically different
version. 

### Option 1

```
include "jpm_packages/service_a/include/default_port.iol"
include "jpm_packages/service_b/include/default_port.iol"
```

List the complete path, we now become dependent on a particular implementation
of where packages are saved. This syntax is also very verbose.

### Option 2

```
include "service_a/default_port.iol"
include "service_c/default_port.iol"
```

Here we inject into the path in two ways. Firstly we add the `jpm_packages`
implicitly, along with also adding `include` within a package. This can be
problematic to implement, it may also be hard to understand for users.

### Option 3

```
include "service_a" "default_port.iol"
include "service_b" "default_port.iol"
```

Introduce a new syntax of the following format:

```
include <package_name> <file>
```

This requires Jolie to have knowledge of the existance of packages. The search
path is only injected in front of the file. Which is how it works currently.

### Option 4

```
from "service_a" import "default_port.iol"
from "service_b" import "default_port.iol"
```

Similar to option 3, but different syntax. This would also introduce a new
keyword `from` which would techincally be a breaking change.

## Includes within a Package

__Problem:__ When includes are performed within a package, the default search
path won't be sufficient. The current search path would be relative to the
client, this should instead be relative to the package.

__Proposed changes:__ Automatically inject the correct search path for
includes which come from a package. This means we much track the parsing context
such that we can detect this case.

## Classpath Additions from Packages

__Problem:__ JAR files included in a packages should be added to the classpath.
Currently the Jolie interpreter is (by default) passed the "lib" folder relative
to the current directory. This won't capture the lib folders of the packages
added by the manager.

__Proposed changes:__ Search through all added packages and add their lib
folders to the classpath.
