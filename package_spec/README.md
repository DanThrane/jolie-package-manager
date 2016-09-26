# Package Specification

This document covers the specification of the file which defines a package. The
format used for this document will be JSON, but the format and whether or not to
allow for several documents is still up for discussion. For now we should avoid
using any features which the generic Jolie value cannot support.

## Purpose

The purpose of the package document is to define what a package is. Every Jolie
package will contain such a document, and it describes several important
properties about the package. These properties are described in the section
"Format and Properties".

## Table of Contents

<!-- MarkdownTOC -->

- [Format and Properties](#format-and-properties)
    - [name](#name)
    - [version](#version)
    - [license](#license)
    - [authors](#authors)
    - [private](#private)
    - [dependencies](#dependencies)
    - [dependency](#dependency)
        - [name](#name-1)
        - [version](#version-1)
        - [registry](#registry)
    - [registries](#registries)
    - [registry](#registry-1)
        - [name](#name-2)
        - [location](#location)

<!-- /MarkdownTOC -->


## Format and Properties

<!--
Property template:

__Name:__ `property_name`

__Optional:__ true/false

__Type:__ `object/string/array<*>/int/boolean/...`

__Description:__

__Rules:__

__TODO:__
-->

### name

__Name:__ `name`

__Optional:__ false

__Type:__ `string`

__Description:__ The `name` property uniquely defines a package in a registry.
Every registry must only contain a single package with a given name. 

__Rules:__

  - The name of a package is _not_ case-sensitive
  - The length of a name is less than 255 characters
  - Names are US-ASCII
  - Names may only contain unreserved URI characters (see section 2.3 of 
    [RFC 3986](https://www.ietf.org/rfc/rfc3986.txt))

If any of these rules are broken the JPM tool should complain when _any_ command
is invoked. Similarly a registry should reject any such package.

__TODO:__

  - Discuss the rules proposed here

### version

__Name:__ `version`

__Optional:__ false

__Type:__ `string`

__Description:__ This property describes the current version of this package.

__Rules:__

  - The version string must be a valid SemVer 2.0.0 string (see 
    http://semver.org/spec/v2.0.0.html)

__TODO:__

  - Discuss the rules propsed here

### license

__Name:__ `property_name`

__Optional:__ false

__Type:__ `string`

__Description:__ Describes the license that this package is under.

__Rules:__

  - Using a valid SPDX identifier might work https://spdx.org/licenses/ TODO

__TODO:__

  - TODO How should a license be expressed
  - Should the property be mandatory?

### authors

__Name:__ `authors`

__Optional:__ false

__Type:__ `array<string>`

__Description:__ Describes the authors of this package

__Rules:__

  - The array must contain at least a single entry
  - Each entry should follow this grammar:

```
name ["<" email ">"] ["(" homepage ")"]
```

__TODO:__
 
  - The grammar needs to be formal
  - Encoding etc.

### private

__Name:__ `private`

__Optional:__ true

__Type:__ `boolean`

__Description:__ Describes if this package should be considered private. If a
package is private it cannot be published to the "public" repository.

__Rules:__

  - By default this property has the value of `true` to avoid accidential
    publishing of private packages.

### dependencies

__Name:__ `dependencies`

__Optional:__ true

__Type:__ `array<dependency>`

__Description:__ Contains an array of dependencies. See the "dependency"
sub-section for more details.

__Rules:__

  - If the property is not listed, a default value of an empty array should be
    used

### dependency

__Type:__ `object`

__Description:__ A dependency describes a single dependency of a package. This
points to a package at a specific point on a specific registry.

#### name

__Name:__ `name`

__Optional:__ false

__Type:__ `string`

__Description:__ Describes the name of the dependency. This refers to the
package name, as defined earlier.

__Rules:__ A dependency name follows the exact same rules as a package name.

#### version

__Name:__ `version`

__Optional:__ false

__Type:__ `string`

__Description:__ Describes the version to use

__Rules:__

  - Must be a valid SemVer 2.0.0 string
  - (This property follows the same rules as the package version does)

__TODO:__

  - Should we allow a package to be less strict about which version to use? For
    example we might allow ranges of versions to be used. For example
    `">=2.0.0"` could describe that the newest version above `2.0.0` should be
    used.

#### registry

__Name:__ `registry`

__Optional:__ true

__Type:__ `string`

__Description:__ This describes the exact registry to use. If no registry is
listed the "public" registry will be used.

__Rules:__

  - The value of this property must be a valid registry as listed in the
    `registries` property.

### registries

__Name:__ `registries`

__Optional:__ true

__Type:__ `array<registry>`

__Description:__ Contains an array of known registries. See the registry
sub-section for more details.

__Rules:__

  - This property contains an implicit entry which points to the public
    registry. This registry is named "public".

### registry

__Type:__ `object`

__Description:__ A registry describes a single JPM registry. A JPM registry
is where the package manager can locate a package, and also request a specific
version of a package.

#### name

__Name:__ `name`

__Optional:__ false

__Type:__ `string`

__Description:__ This property uniquely identifies the registry.

__Rules:__

  - A name cannot be longer than 1024 characters
  - The name cannot be "public"
  - No two registries may have the same name

__TODO:__

  - Encoding of name
  - Should the length limit be dropped? There is no technical reason for the 
    limit

#### location

__Name:__ `location`

__Optional:__ false

__Type:__ `string`

__Description:__ Describes the location of the registry.

__Rules:__

  - Must be a valid Jolie location string (e.g. "socket://localhost:8080")

__TODO:__

  - We probably only want to allow a subset of location strings. For example
    auto bound locations doesn't make a lot of sense in this context.
