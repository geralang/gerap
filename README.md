# The Gera Package Manager

The package manager for [the Gera programming language](https://github.com/typesafeschwalbe/gerac).

## Dependencies

`gerap` requires `git`, `gerac` and a C compiler to function. By default, `gerap` will expect these to be in the PATH (as `git`, `gerac` and `cc` respectively). To overwrite this, alternative paths for each may be specified using the `GERAP_GIT_PATH`, `GERAP_GERAC_PATH` and `GERAP_CC_PATH` environment variables.

Additional arguments for the C compiler may be specified by the `GERAP_CC_ARGS` environment variable.

## CLI Usage

```
gerap new <name>
```
Creates a new package with the name `<name>` in a new directory with the same name.

```
gerap init
```
Creates a new package in the current directory, named after the name of the current directory.

```
gerap build
```
Builds the package in the current directory, putting the output into `./.gerap` Requires that this package defines a main procedure in its configuration file.

```
gerap run
```
Builds the package in the current directory and runs the resulting binary. Requires that this package defines a main procedure in its configuration file, that `target = "c"` and that the C compiler used generates an executable that can be run on the current platform.

```
gerap clean
```
Deletes the `.gerap`-directory (output directory). This will result in all  non-local dependencies being downloaded again the next time the package is built.

## Package Configuration (`config.gpc`)

A package is defined by its `config.gpc`. When a new package is created with `gerap new <name>` or `gerap init`, the default configuration file looks like this:
```
name = "<name of package>"
description = ""
authors = ["<name of user>"]
version = "0.1"
target = "c"
dependencies = [
    <https://github.com/typesafeschwalbe/gerastd-c>
]
main = "test::main"
```

The file consists of a list of properties, each of which either being:
- a string (e.g. `"this is a string"`)
- a git repository (e.g. `<https://github.com/typesafeschwalbe/gerastd>`)
- a list of strings (e.g. `["John Doe" "Bob Smith" "Chris Hunter"]`, note that they are not comma-separated)
- a list of packages (e.g. `[<https://github.com/typesafeschwalbe/gerastd-c> "./cool-parser-lib" "./is_even"]`, note that they are not comma-separated)

### List of Properties

- `name`
  The name of the package. Must be a string that only contains `a-z`, `A-Z`, `0-9` or `_`.
- `target`
  The target format of the package. Must be a string that's either `c`, `js` or `any`.
  *Packages may only depend on other packages with the same target format or target format `any`.*
- `dependencies`
  A list of dependencies of the package. Must be a list of strings or git repositories, each either being a Git-repository or a local directory with a `config.gpc`-file at its root.
- `main` *(optional)*
  The full path of the main procedure. Must be a string.
  *Note that not specifying a main procedure does not allow you to build or run this package, only to use it as a dependency.*
- `description` *(optional)*
  A description of the package. Must be a string.
- `authors` *(optional)*
  The authors of the package. Must be a list of strings.
- `version` *(optional)*
  The version of the package. Must be a string.
- `build` *(optional)*
  A command to run when processing the package. Must be a string.
  Note that `@GERAP_GIT_PATH`, `@GERAP_GERAC_PATH`, `@GERAP_CC_PATH` and `@GERAP_CC_ARGS` will be replaced with the respective values `gerap` is using internally before the command is executed.
- `link` *(optional)*
  A list of files to pass to the C compiler when a binary is made. Must be a list of strings. Requires that `target = "c"`.
- `include` *(optional)*
  A list of files to copy into the output directory (`.gerap`). Must be a list of strings.