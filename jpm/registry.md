# Registry

A JPM registry is at the core of the JPM. A registry is what JPM will have to
contact almost regardless of the command invoked. The core responsibilities of
a registry is as follows:

  - Search for packages
  - Query a specific package
    + All versions
    + All dependencies for each version
    + Meta-data for each version (i.e. name, license, tags, etc.)
  - Publishing for packages and handling who has the rights to perform these
    actions.

## Permissions

Certain permissions are used from the `authorization` service, to determine if
a user is allowed to perform an action. TODO Insert which are used. Should be
in another document somewhere.

To set default (and guest) rights, use the following configurtion keys for the
`authorization` service that the `registry` depends on:

  - `AUTH_DEFAULT_RIGHTS`: Sets the default rights of a user
  - `AUTH_GUEST_RIGHTS`: Sets the default rights of a guest

We also want:

  - Are you allowed to create a new user? Or should only admins be able to
    create new users?
  - In that case we also need admins, and allow them to create new users on
    demand. We can probably add a super-user in the configuration? Let that
    super-user actually do dynamic admins.

## Registry Collaboration

Some registries (typically non-public) require that a package may depend on
packages published to other registries.
