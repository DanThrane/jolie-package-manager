# Planned Features and Issues

## Table of Contents

<!-- vim-markdown-toc GFM -->
* [Lock Files](#lock-files)
* [Integrity Checks](#integrity-checks)
* [Registry Teams](#registry-teams)
* [Scripts for Life-time Events](#scripts-for-life-time-events)
    * [Simple Implementation Proposal](#simple-implementation-proposal)
* [Cross-Registry Dependencies](#cross-registry-dependencies)
* [Interface Dependencies](#interface-dependencies)
* [Aggregations](#aggregations)

<!-- vim-markdown-toc -->

## Lock Files

Introduce lock files to the package manager.

This feature will deal with a problem that some package manager suffers from.
Namely that the same package manifest can give different versions of the same
packages. The problem comes from supporting SemVer expressions (e.g. `1.0.X`).
This feature is very convenient, but can also cause problems, since we cannot
be certain which versions will be installed, hence a server doing a fresh
install might get different dependencies, which will end up breaking the build.

A common fix for this problem is to use lock files. These files are essentially
"locked" versions of each dependency. This way `jpm install` will always
install the versions in the lock file, if it is present. When versions are
initially picked, either through `jpm upgrade` or `jpm install` with no lock
file, we can still use the expressions.

Related work:

  - http://yarnpkg.com
  - http://crates.io/

---

Let the upgrade script adopt the old behavior, and find the newest, and update
the lockfile. This should be fairly easy. This is done.

Perhaps also add an interactive mode?

## Integrity Checks

Introduce integrity checks for packages.

Possible use-cases:

  - Check for accidental/malicious corruption of dependency
  - Check for manual changes to source code

---

Add an endpoint for the registry which answers back with a checksum. Cache
this checksum locally for comparisons. Also compute new checksum, if any of
them don't match complain loduly.

## Registry Teams

Allow more flexibility in who has rights to publish updates.

## Scripts for Life-time Events

Possible life-time events:

  - Pre/Post-publish
  - Pre/Post-start
  - Pre/Post-install
  - Pre/Post-upgrade

Possible use-cases:

  - Build scripts (for embedded services)
  - Code generation (e.g. `jolie2surface`)
  - Code linting/Perform checks before publishing version

### Simple Implementation Proposal

Add a new `events` section which can run scripts, for example:

```json
{
    "events": {
        "pre-start": "./build",
        "pre-publish": "./runchecks"
    }
}
```

If the pre scripts fail (i.e. non-zero exit code) we could prevent the original
action from being run. This way allowing us to run checks and prevent
accidental publishing of code.

## Cross-Registry Dependencies

There needs to a policy in place for dealing with publishing of packages that
have cross-registry dependencies.

For example: Package A depend on B which is from a non-public registry. We
shouldn't allow A to be published to a public registry.

However if: Package A depend on B from a public-registry. Then we probably
should allow A to be published to a non-public registry.

This should probably be implemented as some configuration in the registry.
Whitelist/blacklist of cross-registry collaboration?

Alternatively we could do registry mirroring. __[Let's wait and see, go with
other approach for now]__

---

Implementing this is very easy actually. In the configuration we just need to
add known locations of registries. We then just check every dependency to see
if we can reach it. We don't have to care about reaching these dependencies,
we simply delegate this to the frontend.

## Interface Dependencies

The dependencies we need to download will change drastically depend on how we
depend on another package.

Certain dependencies are only needed to interface with it

---

Do we need to deal with libraries? We probably don't want to include these
as well.

## Aggregations

Done. Hopefully
