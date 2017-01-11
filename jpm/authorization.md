# Authorization in JPM

Authorization with a registry will give us a token. We save this token locally.
Stored in plain-text. Attempting to 'encrypt' it won't do us much good, unless
we require a password every time. In that case it really doesn't matter. We will
need to store these tokens for every known registry. We could have an option for
not saving this token, thus requiring a login for every action.

```
jpm login [--registry <registryName>]
jpm logout [--registry <registryName>]
jpm whoami [[--registry <registryName>]]
```

Two types of packages:

  1. public
  2. internal

Public packages allow everyone to read the package. Uses access matrix for write
rights.

Internal packages have access matrix for all options. Nothing is allowed by
default.

Allowing internal packages to become public shouldn't be a problem. However
letting public packages become internal is a problem. This is essentially the
same as deleting a public package from the registry. This can 
[cause problems](http://www.theregister.co.uk/2016/03/23/npm_left_pad_chaos/).

These two types are clearly very alike. We make the distinction solely such that
a public registry may disallow or partially restrict internal use. A public
registry might for example provide free hosting for public packages but paid for
internal. We might want to require a fresh token for such an action. We may even
want to provide a grace period, in which the package isn't public yet, and the
action can be reversed.

The access matrix have entries for groups. A single member is modeled by a
singleton group. 

## Package Ownership

Every package creates a new authorization group. This group is granted RW
privileges. The user who initially publishes this package is added to this
group. Additionally this user gets an additional right, which allows super-
privileged actions to occur on the package. This would for example include
transfer of super-privileges.

```
jpm ownership add <user> [--super]
```

Adds another owner to this project. This effectively adds a new user to the
group owning this. We can additionally add super-privileges.

```
jpm ownership remove <user>
```

Removes an owner from this project. This can only be done super-privileged
users.

```
jpm ownership move <team/user>
```

Transfers complete ownership to another team or user. The existing group
maintaining this loses all rights (unless they happen to be in the new team).
This can only be done by super-privileged users.

## Teams

Teams are just another category of groups, like package maintainer groups are.
These are however explicitly created (as opposed to package maintainer groups).
These are managed using the following commands:

```
jpm team create <name>
```

Creates a new team. These names must be unique among both team names and user
names! Thus they are also under the same constraints as user names. The user
creating the team is automatically added and granted super-privileges. 

```
jpm team add <team-name> <user> [--super]
```

Adds a new team-member. Optionally with super-privileges. Can only be done by
super-privileged members.

```
jpm team remove <team-name> <user>
```

Removes a user from the team. Can only be done by super-privileged members.
