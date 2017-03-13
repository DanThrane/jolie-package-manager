# Commands

This document contains a complete list of commands available in JPM.

## Table of Contents

<!-- vim-markdown-toc GFM -->
* [help](#help)
* [init](#init)
* [install](#install)
* [search](#search)
* [start](#start)
* [publish](#publish)
* [whoami](#whoami)
* [register](#register)
* [login](#login)
* [logout](#logout)
* [cache](#cache)
* [ping](#ping)

<!-- vim-markdown-toc -->

## help

Usage: `jpm help [COMMAND]`

Displays general help for the JPM tool or a specific `COMMAND`.

## init

Initializes a repository in the current directory.

Usage: `jpm init`

This will start a command-line wizard which guides you through the
initialization process. This command will create a new folder in the current
directory with the name of the package.

Example:

```
$ ls
$ jpm init
Package name
------------
> foo

Package description
-------------------
> bar

Author: [Format: name <email> (homepage)]
-----------------------------------------
> Dan Sebastian Thrane <dthrane@gmail.com> (github.com/DanThrane)

Private package? [Y/n]
----------------------
> n

$ ls
foo
```

## install

Installs the dependencies of this package.

Dependencies are loaded from package.json .... TODO

## search

Searches known registries for a package.

Usage: `jpm search <query>`

## start

Starts the package placed in the working directory.

Usage: `jpm start [OPTIONS] [PROGRAM-ARGUMENTS]`

Options:

  - `--deploy <profile> <configurationFile>`: Uses a deployment profile
  - `--verbose`: Verbose output
  - `--debug <suspend> <port>`: Uses `joliedebug` as the interpreter

## publish

Publishes this package.

## whoami

Outputs the user you're logged in as with a registry.

Usage: `jpm whoami [--registry <NAME>]`

If no registry is given it will be set to 'public'.

## register

Create a new user with a registry.

Usage: `jpm register [--registry <NAME>] [<USERNAME> <PASSWORD>]`

If no registry is given it will be set to 'public'. If no username and password
is provided a login prompt will be shown.

## login

Login to a given registry.

Usage: `jpm login [--registry <NAME>] [<USERNAME> <PASSWORD>]`

By default the registry name will be set to 'public'. A login prompt is shown
if no username or password is provided.

## logout

Logout from a registry.

Usage: `jpm logout [--registry <NAME>]`

If no registry is provided it will be set to 'public'.

## cache

Command which deals with the cache.

Usage: `jpm cache <SUBCOMMAND>`

Available sub-commands:

clear       Clear the cache

## ping

Ping a registry.

Usage: `jpm ping [--registry <NAME>]`

If no registry is given it will be set to 'public'.

