# (Configuration) Using Language Integration

__Problem:__ Passing configurations via constants happen late in the code
interpretation phase. This leads to several problems, such as certain things not
being configurable (e.g. input ports).

__Proposed solution:__ Allow configuration at the language level. This way we
can push into a sufficiently early level. This will also open up new
possibilities such as integrating it with `jolie --check`.

## Configurable Constructs

Jolie provides a number of constructs, which could potentially be configurable.
These are:

  - Input ports
  - Output ports
  - Constants

Every construct which should be configurable must be explicitly marked as such.
Configuration of non-configurable constructs will result in an error. Constructs
can be marked as configurable using a new keyword (for example `ext`). For ports
this could be done in the following way:

```jolie
ext outputPort Foo {
    Interfaces: FooIface
    // Location, protocol and protocol parameters filled in by external
    // configuration
}

constants {
    ext FOO,
    ext BAR,

    A_NON_EXTERNAL_CONSTANT = 42
}
```

If we require types to be listed (see Discussion[6]):

```jolie
constants {
    ext FOO: int,
    ext BAR: int | string | userType,

    A_NON_EXTERNAL_CONSTANT = 42
}
```

## Configuration Files

The configuration files are static files, which contain no logic. When it comes
to the format of the configuration files it won't matter much, but the format
should be able to support the generic Jolie value type.

Here I will propose using either a generic format, which supports Jolie's value
type. The other format will be inspired by the current Jolie syntax.

In this example we will take the following constructs, and make them
configurable (with a configuration which matches the original).

__Code before:__

```jolie
constants {
  MY_CONFIGURABLE_CONSTANT = 42
}

outputPort MyService {
  Interfaces: MyServiceIface
  Location: "socket://example.org:80"
  Protocol: http {
    .keepAlive = false, 
    .debug = true, 
    .debug.showContent = false
  }
}
```

__Code after:__

```jolie
constants {
  ext MY_CONFIGURABLE_CONSTANT: int
}

ext outputPort MyService {
  Interfaces: MyServiceIface
}
```

__Generic Format Configuration:__

For the generic format we will be able to support multiple formats. These should
follow the same serialization/deserialization semantics that Jolie already does.
An example here is given in JSON:

```json
{
  "default": {
    "MY_CONFIGURABLE_CONSTANT": 42,
    "MyService": {
      "location": "socket://example.org:80",
      "protocol": {
        "$$": "http",
        "debug": {
          "$$": true,
          "showContent": false
        }
      }
    }
  }
}
```

__Jolie-like Configuration:__

```jolie
MY_CONFIGURABLE_CONSTANT = 42,

outputPort MyService {
  Location: "socket://example.org:80"
  Protocol: http {
    .keepAlive = false, 
    .debug = true, 
    .debug.showContent = false
  }
}
```

Using a Jolie-like configuration can be nice, and gives us a more familiar
syntax. However we can only support a very limited part of the Jolie language in
the configuration files. However this way we won't have weird compatibility
issues with Jolie generic value.

### Meta Section

Create a reserved section named "meta". In this section we will be able to place
configuration for the configuration file itself. This will allow us to create
new features for the configuration system. This could for example be used to
create a system which pulls configuration from an external server. For example a
configuration file could contain the following section:

```json
"meta": {
    "useConfigurationServer": true,
    "configurationServer": {
        "location": "socket://configuration.example.org:51234",
        "parameters": {
            "type": "MyServiceType",
            "profile": "production"
        }
    }
}
```

```jolie
region meta {
  useConfigurationServer = true;

  with (configurationServer) {
    .location = "socket://configuration.example.org:51234";
    
    with (.parameters) {
      .type = "MyServiceType";
      .profile = "production";
    }
  }
}
```

Which would, instead of pull values from the file contact the `location` with a
request for configuration matching type, profile and service name.

Details for such as system remains. But if we reserve a section for this purpose
we should be able to implement this at a later point, without breaking any code.

https://github.com/spring-cloud/spring-cloud-config

## Service Names and Integration with Packages

__Problem:__ From within a package it should be able to launch a dependency
server. It should be possible to launch these with different types of
configurations.

__Proposed solution:__ Introduce service names, this name can be given when the
server is started. For example:

```bash
jolie --service-name <serviceName> --start-package <packageName> 
```

This command would start the package given by `<packageName>` (for more info see
the [/package_spec/README.md](package specification)). The service launched will
use configuration given to service which uses that name. In the configuration
files this will be done by having regions at the root level which configure only
the service with that name. For example:

```json
{
  "<serviceName>": {
    "MY_CONFIGURABLE_CONSTANT": 42,
    "MyService": {
      "location": "socket://example.org:80",
      "protocol": {
        "$$": "http",
        "debug": {
          "$$": true,
          "showContent": false
        }
      }
    }
  }
}
```

```jolie
region <serviceName> {
  MY_CONFIGURABLE_CONSTANT = 42,

  outputPort MyService {
    Location: "socket://example.org:80"
    Protocol: http {
      .keepAlive = false, 
      .debug = true, 
      .debug.showContent = false
    }
  }
}
```

We provide a "default" region which is used if no service name is given at
deployment.

__Problem:__ In certain cases a package may want to provide configuration for
some of its dependencies. If a client embeds this service it should be able to
re-use this same configuration without restating it.

__Proposed solution:__ Read and merge configuration files in a bottom-up
fashion. Allow each configuration file to override existing properties. That way
a client can override configuration of a dependency (Any limitations on this?
Discussion[7]).

## Discussion

  1. Which constructs should be configurable? Should there be any limitations as
     to how they can be configured?
  2. Should all configurable constructs be marked as external before they can be
     configured?
  3. Constants are already configurable with the `-C` command line argument. The
     idea of having to expliclty mark construct as configurable goes against the
     functionality provided by `-C`. How should we handle this behavior going
     forward, if we choose to require each construct to be marked?
  4. Should user defined types be allowed in configuration?
  5. Is there any reason for configuring both constants and variables? Should
     configuration variables be changed at run-time?
  6. Should configurable constants and variables have type information?
  7. Should there be any limitation to when we can override configuration?
