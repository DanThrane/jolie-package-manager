# Jap Files

The current syntax for including a service is rather verbose, for example:

```
include "jar:file:./git.jap!include/embed.iol"
```

Instead of:

```
include "git/embed.iol"
```

## Issues

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
