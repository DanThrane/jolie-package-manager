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
* [Sharing of Embedded Instances](#sharing-of-embedded-instances)
* [Static Embedding Across Multiple Levels](#static-embedding-across-multiple-levels)
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

## Integrity Checks

Introduce integrity checks for packages.

Possible use-cases:

  - Check for accidental/malicious corruption of dependency
  - Check for manual changes to source code

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

## Interface Dependencies

The dependencies we need to download will change drastically depend on how we
depend on another package.

Certain dependencies are only needed to interface with it

## Sharing of Embedded Instances

Should it be possible to share an embedded instance? How should we allow this?

__Probably not__

## Static Embedding Across Multiple Levels

We need some way of fixing this. We should be able to refer to internal conf
units. Obvious example of this would be from the article.

__This is a syntax problem, evaluate different options and implement it.__

## Aggregations

Inconsistencies in language (currently). We don't really check a whole lot on
the interface, which makes several of the obivious feature here redundant.

At that point are we really left with anything other than simply adding the
operations at deployment time to `port.aggregatedOperations`?

__Wait for a bit.__
