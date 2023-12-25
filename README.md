# The Gera Package Manager

The package manager for [the Gera programming language](https://github.com/typesafeschwalbe/gerac).

## Installation

### Dependencies

`gerap` has the following dependencies (some of which might not be needed depending on your use case), which shall be in the PATH or overwritten with their respective environment variables if needed:
- `git`
  - default is `git`, overwrite with `GERAP_GIT_PATH`
  - required when a git repository containing a package is used as a dependency
- `gerac`
  - default is `gerac`, overwrite with `GERAP_GERAC_PATH`
  - required when Gera source code is compiled
- A C compiler
  - default is `cc`, overwrite with `GERAP_CC_PATH`, specify arguments with `GERAP_CC_ARGS`
  - required when a package with `target = "c"` is built or ran
- `node`
  - default is `node`, overwrite with `GERAP_NODE_PATH`)
  - required when a package with `target = "js"` is ran

### Pre-built binaries

Pre-built binaries of the latest release are available for x86_64 on Windows, Linux and macOS. Consider building from source for other targets.

### Building from source

To build `gerap` from source, clone the repository and run `build.sh`. This requires `git`, `gerac` and a C compiler (under the alias `cc`) to be in the PATH.

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
Builds the package in the current directory and runs the resulting binary. Requires that:
- This package defines a main procedure in its configuration file
- `target = "c"` or `target = "js"`
- *(when `target = "c"`)* the C compiler used generates an executable that can be run on the current platform
- *(when `target = "js"`)* the resulting file can be interpreted by a Javascript engine (e.g. Node.js)

```
gerap clean
```
Deletes the `.gerap`-directory (output directory). This will result in all  non-local dependencies being downloaded again the next time the package is built.

### Disabling Color

To disable colored output, set the `GERAP_COLORED_OUTPUT` environment variable to something other than `true`.

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
    - The name of the package.
    - Must be a string that only contains `a-z`, `A-Z`, `0-9` or `_`.
- `target`
    - The target format of the package.
    - Must be a string that's either `c`, `js` or `any`.
    - *Packages may only depend on other packages with the same target format or target format `any`.*
- `dependencies`
    - A list of dependencies of the package.
    - Must be a list of strings or git repositories, each either being a Git-repository or a local directory with a `config.gpc`-file at its root.
- `main` *(optional)*
    - The full path of the main procedure.
    - Must be a string.
    - *Note that not specifying a main procedure does not allow you to build or run this package, only to use it as a dependency.*
- `description` *(optional)*
    - A description of the package.
    - Must be a string.
- `authors` *(optional)*
    - The authors of the package.
    - Must be a list of strings.
- `version` *(optional)*
    - The version of the package.
    - Must be a string.
- `build` *(optional)*
    - A command to run when processing the package.
    - Must be a string.
    - Note that `@GERAP_COLORED_OUTPUT`, `@GERAP_GIT_PATH`, `@GERAP_GERAC_PATH`, `@GERAP_CC_PATH`, `@GERAP_CC_ARGS` and `@GERAP_NODE_PATH` will be replaced with the respective values `gerap` is using internally before the command is executed.
- `build_c` *(optional)*
    - A command to run when processing the package. Will only be executed if the root target type (not the target of this package, but the target type that will be generated) is `"c"`.
    - Must be a string.
    - Note that `@GERAP_COLORED_OUTPUT`, `@GERAP_GIT_PATH`, `@GERAP_GERAC_PATH`, `@GERAP_CC_PATH`, `@GERAP_CC_ARGS` and `@GERAP_NODE_PATH` will be replaced with the respective values `gerap` is using internally before the command is executed.
- `build_js` *(optional)*
    - A command to run when processing the package. Will only be executed if the root target type (not the target of this package, but the target type that will be generated) is `"js"`.
    - Must be a string.
    - Note that `@GERAP_COLORED_OUTPUT`, `@GERAP_GIT_PATH`, `@GERAP_GERAC_PATH`, `@GERAP_CC_PATH`, `@GERAP_CC_ARGS` and `@GERAP_NODE_PATH` will be replaced with the respective values `gerap` is using internally before the command is executed.
- `link_c` *(optional)*
  - A list of files to pass to the C compiler when a binary is made. Will only be linked if the root target type (not the target of this package, but the target type that will be generated) is `"c"`.
  - Must be a list of strings.
- `link_js` *(optional)*
  - A list of files whose contents shall be inserted at the top of the output file. Will only be linked if the root target type (not the target of this package, but the target type that will be generated) is `"js"`.
  - Must be a list of strings.
- `include` *(optional)*
  - A list of files to copy into the output directory (`.gerap`).
  - Must be a list of strings.  
- `include_c` *(optional)*
  - A list of files to copy into the output directory (`.gerap`). Will only be included if the root target type (not the target of this package, but the target type that will be generated) is `"c"`.
  - Must be a list of strings.
- `include_js` *(optional)*
  - A list of files to copy into the output directory (`.gerap`). Will only be included if the root target type (not the target of this package, but the target type that will be generated) is `"c"`.
  - Must be a list of strings.