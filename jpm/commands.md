# JPM Commands

<!--
Command template:

__Name:__

__Usage:__

__Description:__

__Example:__
-->

```
type JPM::CommandContext: void {
    .workingDirectory: File
}
```

## jpm-package

__Name:__ `package`

__CLI-Usage:__ `jpm package`

__Request:__

```
type JPM::PackageRequest: void {
    .context: JPM::CommandContext
}
```

__Response:__

```
type JPM::PackageResponse: void {
    .package: JPM::Package
}
```

__Description:__ Displays information about the package listed in the current
working directory.

__Example:__

```
$ jpm package
{
    "name": "client",
    "version": {
        "major": 1,
        "minor": 0,
        "patch": 0,
        "label": null
    },
    "dependencies": [],
    "license": "MIT",
    "authors": [
        {
            name: "Author 1",
            email: null,
            homepage: null
        }
    ]
}
```

Note that this is not the same as the contents of `package.json` rather this is
an actually fully parsed version of it serialized as JSON.

## jpm-version

__Name:__ `version`

__CLI-Usage:__ `jpm version`

__Request:__

```
type JPM::VersionRequest: void {
    .context: JPM::CommandContext
}
```

__Response:__

```
type JPM::VersionResponse: void {
    .productName: string
    .version: SemVer
    .releaseDate: ISO8601Date
}
```

__Description:__ Outputs the current version of JPM. 

__Example:__

```
$ jpm version
JPM
1.0.0
2016-09-26
```

```
$ jpm version --format json
{
    "product_name": "JPM",
    "version": "1.0.0",
    "release_date": "2016-09-26"
}
```

## jpm-init

__Name:__ `init`

__CLI-Usage:__ `jpm init`

__Request:__

```
type JPM::InitRequest: void {
    .context: JPM::CommandContext
    .name?: string
    .license?: string
    .authors[0,*]: JPM::Author
}
```

__Response:__

```
type JPM::InitResponse: void
```

__Description:__ Displays an interactive initialization wizard. This command
will fail if this working directory contains a package. Otherwise this will
result in a newly created package document (see
[package_spec](/package_spec/README.md)).

__Example:__

```bash
$ mkdir client
$ cd client
$ jpm init
Name [client]:
>
License [MIT]:
>
Authors:
> Author 1, Author 2

Generated 'package.json'
$ cat package.json
{
    "name": "client",
    "version": "1.0.0",
    "dependencies": [],
    "license": "MIT",
    "authors": ["Author 1", "Author 2"]
}
```

## jpm-install

__Name:__ `install` 

__CLI-Usage:__ `jpm install`

__Request:__

```
type JPM::InstallRequest: void {
    .context: JPM::CommandContext
}
```

__Response:__

```
type JPM::InstallResponse: void
```

__Description:__ Reads the package document, retrieves the dependencies,
contacts the registires to pull the correct packages.

__Example:__

This shows an example of a client which depends on a service called `service_a`

```
$ ls
package.json client.ol
$ jpm install
Installing dependencies... Done
$ ls
package.json client.ol jpm_packages
$ ls jpm_packages
service_a
```

## jpm-publish

__Name:__ `publish`

__CLI-Usage:__ `jpm publish [registry]`

The registry has a default value of "public"

__Request:__

```
type JPM::PublishRequest: void {
    .context: JPM::CommandContext
    .registry?: string
}
```

__Response:__

```
type JPM::PublishResponse: void
```

__Description:__ Publishes the package found in the current working directory to
`registry`.

__Example:__

```
$ cd $CALCULATOR_HOME
$ jpm publish
Are you sure you wish to release Calculator at version 1.0.0 to 
<registry>? [y/N]
> y
Uploading Calculator@1.0.0 to <registry>
... Done
```

## jpm-add-dependency

__Name:__ `add-dependency`

__CLI-Usage:__ `jpm add-dependency [name [version] [registry]]`

The registry will default to "public".

__Request:__

```
type JPM::AddDependencyRequest: void {
    .context: JPM::CommandContext
    .name: string
    .version: SemVer
    .registry?: string
}
```

__Response:__

```
type JPM::AddDependencyResponse: void
```

__Description:__ Adds a dependency to the package document. If the name or
version is missing the command will start interactive mode, which will guide you
through the process.

__Example:__

Interactive mode is shown in the following example:

```
$ jpm add-dependency Calculator
Found package 'Calculator' latest version is 1.0.0

Version [1.0.0]:
>

Added dependency to package.json

$ cat package.json
{
    "name": "client",
    "version": "1.0.0",
    "dependencies": [
        {
            "name": "Calculator",
            "version": "1.0.0"
        }
    ],
    "license": "MIT",
    "authors": ["Author 1", "Author 2"]
}
```

If everything is listed, the process is slightly shorter:

```
$ jpm add-dependency Calculator 1.0.0 public
Found package 'Calculator' at version 1.0.0 in registry "public"

Added dependency to package.json

$ cat package.json
{
    "name": "client",
    "version": "1.0.0",
    "dependencies": [
        {
            "name": "Calculator",
            "version": "1.0.0"
        }
    ],
    "license": "MIT",
    "authors": ["Author 1", "Author 2"]
}
```

## jpm-start-package

