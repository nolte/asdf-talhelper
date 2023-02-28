<div align="center">

# asdf-talhelper [![Build](https://github.com/nolte/asdf-talhelper/actions/workflows/build.yml/badge.svg)](https://github.com/nolte/asdf-talhelper/actions/workflows/build.yml) [![Lint](https://github.com/nolte/asdf-talhelper/actions/workflows/lint.yml/badge.svg)](https://github.com/nolte/asdf-talhelper/actions/workflows/lint.yml)


[talhelper](https://github.com/budimanjojo/talhelper) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add talhelper
# or
asdf plugin add talhelper https://github.com/nolte/asdf-talhelper.git
```

talhelper:

```shell
# Show all installable versions
asdf list-all talhelper

# Install specific version
asdf install talhelper latest

# Set a version globally (on your ~/.tool-versions file)
asdf global talhelper latest

# Now talhelper commands are available
talhelper --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Development

export ASDF_INSTALL_VERSION=1.6.1
export ASDF_DOWNLOAD_PATH=/tmp/asdf-debug/downloads/
export ASDF_INSTALL_PATH=/tmp/asdf-debug/bin/
export ASDF_INSTALL_TYPE=version
./bin/download

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/nolte/asdf-talhelper/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [nolte](https://github.com/nolte/)
