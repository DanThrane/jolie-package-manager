# Lock Files for JPM

JPM will manage a lock file stored in the root directory with the name
`jpm_lock.json`. This file will contain the exact versions of packages required
to run your service. This will allow for consistent dependencies across
multiple installs. This file should not be updated manually, and should be
checked into source control.

The lock file will contain a mapping between a dependency (package name +
SemVer expression + repository) and a resolved version (i.e. SemVer). The file
schema is as follows:

```json
{
    "_note": "Auto-generated file notice",
    "locked": {
        "Package@X.X.X/Registry": {
            "resolved": "1.2.3",
            "checksum": "..."
        }
    }
}
```

When running `jpm install` this file will be consulted. If a dependency is
found to be locked, then the resolved version will be used. If it is not found
normal semantics apply. Lock files of dependencies are _not_ used.

Using the `jpm upgrade` command you may change this lock file, where you
attempt to upgrade your dependencies to their newest version. This will update
your lock file and dependencies.

