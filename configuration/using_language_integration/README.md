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
  - Global variables

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
```

The fact that Jolie doesn't require us to define a variable before use, makes
the case a bit more complicated for variables. The same applies to constants
with no values. This might be handled by adding new `ext` blocks which list the
constants and variables that should be configurable.

```jolie
ext constants {
    FOO,
    BAR,
    BAZ
}

ext variables {
    // ...
}
```

If we require types to be listed (see Discussion[7]):

```jolie
ext constants {
    FOO: int,
    BAR: int | string | userType
}
```

## Configuration Files

The configuration files are static files, which contain no logic. When it comes
to the format of the configuration files it won't matter much, but the format
should be able to support the generic Jolie value type.

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

Which would, instead of pull values from the file contact the `location` with a
request for configuration matching type, profile and service name.

Details for such as system remains. But if we reserve a section for this purpose
we should be able to implement this at a later point, without breaking any code.

https://github.com/spring-cloud/spring-cloud-config

## Discussion

  1. Which constructs should be configurable? Should there be any limitations as
     to how they can be configured?
  2. Should all configurable constructs be marked as external before they can be
     configured?
  3. Constants are already configurable with the `-C` command line argument. The
     idea of having to expliclty mark construct as configurable goes against the
     functionality provided by `-C`. How should we handle this behavior going
     forward, if we choose to require each construct to be marked?
  4. How should configuration deal with namespaces?
  5. Should user defined types be allowed in configuration?
  6. Is there any reason for configuring both constants and variables? Should
     configuration variables be changed at run-time?
  7. Should configurable constants and variables have type information?
  8. Should configuration files be purely static without any logic?
