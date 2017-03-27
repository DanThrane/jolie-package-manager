# Life-time Hooks

A JPM feature that allows for a client to specify life-time hooks, in order to
run scripts before and after certain events occur. Any script running before
a specific event has the option of terminating the event. This can be done
by returning a non-zero exit code. The following is a complete list of
supported hooks:

__Start__

  - `pre-start`: Script is run right before the `start` command is invoked on
    a service.
  - `post-start`: Run right before the `start` command terminates. There is no
    guarantee that this script is run (i.e. if the service was forcefully
    terminated).

__Install__

  - `pre-install`: Runs before the `install` command is invoked.
  - `post-install`: Runs after the `install` command has finished.
  - `on-install`: Runs when this package is being installed as a dependency.
    TODO How do we implement this?

__Publish__

  - `pre-publish`: Runs before the `publish` command is invoked.
  - `post-publish`: Runs after the `publish` command has finished.

