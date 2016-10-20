# Moving from External Use to External Use

![](structure.png)

This example builds on [example 2](example2.md). More specifically we will look
at the database service and discuss going back and forth between using a open
external and open internal.

But first let's look at the internal structure of the database package. The
database service might contain the following files:

```
 - include
  |- database.iol
 - database.ol
 - package.json
```

This layout should be pretty standard, the `database.iol` file contains
interface and type definitions. For example:

```jolie
type SomethingRequest: int
type SomethingResponse: string

interface DatabaseIface {
    RequestResponse:
        doSomething(SomethingRequest)(SomethingResponse)
}
```

`database.ol` contains the implementation, must importantly it contains several
constructs marked as external, those being `USERNAME`, `PASSWORD`, and the input
port:

```jolie
constants {
    USERNAME: string,
    PASSWORD: string
}

ext inputPort Database {
    Interfaces: DatabaseIface
}
```

The outputport for the database is defined inside of A. We can have it be
externally configured:

```jolie
outputPort Database {
    Location: ext
    Protocol: ext
    Interfaces: DatabaseIface
}
```

## Open External

In the case of having the service be open external inside of our client A, we
simply have to do:

```jolie
region a {
    outputPort Database {
        Location: "socket://localhost:13000"
        Protocol: sodep
    }
}

region database {
    USERNAME = "foo"
    PASSWORD = "bar"

    inputPort Database {
        Location: "socket://localhost:13000"
        Protocol: sodep
    }
}
```

And then start the service with the service name "database":

```bash
jolie --service-name database --start-package database
```

The configuration shown above isn't very DRY since we essentially have to
copy&paste the same definition. However since the actual host might be different
and the protocol definition might have different parameters it seems necessary.

## (Open) Internal

Making the input port of the database correct is fairly simple:

```jolie
region database {
    USERNAME = "foo"
    PASSWORD = "bar"

    inputPort Database {
        Location: "local"
    }
}
```

However we still have a few problems remaining:

  1. How does the embedded database know where to look?
  2. How do we perform the embedding from the configuration file?

These two are both fairly coupled. The first question is however fairly simple,
we need to somehow pass the service name. However the second question is a bit
harder to answer.

If the output port that A is wasn't external we would have simply done the
embedding:

```jolie
embedded {
    Jolie:
        "database/database.ol" in Database
}
```

Since this type of embedding technically allows us to pass command-line
arguments we could do:

```jolie
embedded {
    Jolie:
        "--service-name database database/database.ol" in Database
}
```

And simply call it a day. However this solution shows a bit of a weakness in the
configuration system. Since we're now doing what we previously did in external
configurations inside of the source code. This being especially problematic due
to dependencies being read-only.

Instead I suggest we add additional syntax to the configuration files to allow
for embedding. Thus the output port would remain external and the configuration
could look like:

```jolie
region a {
    outputPort Database {
        embedded "database" as "database"
    }
}
```

The syntax being `embedded <packageName> as <serviceName>`. Embedding it should
be trivial, since we already know the main file of that package. (I'm not
personally a fan of the syntax used here, feel free to suggest something better)