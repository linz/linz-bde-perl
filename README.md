[![Actions Status](https://github.com/linz/linz-bde-perl/workflows/test/badge.svg?branch=master)](https://github.com/linz/linz-bde-perl/actions)

# BDE Perl Package

The BDE module can be used to read [LINZ bulk-data extract files](docs/BDE.md).

The module allows for reading the files in text or compressed mode. It also modifies geometry
properties, adding an SRID to the beginning and optionally offsetting the longitude.

The module also includes classes to manage a [BDE repository](docs/BDE_repository.md).

## Simple install

```shell
perl Build.PL
./Build install
```

## Advanced install options

The build system is using perl Module::Build. A full list of the building options are available run:

```shell
./Build help
```

A more complex example involving specific install directories could something like:

```shell
perl Build.PL --prefix=/usr/local
./Build install
```

## Install as a Debian package

A binary Debian package can be built with:

    dpkg-buildpackage -b -us -uc

When successful it will create a .deb and a .changes files one directory above the root of this
repository, something like:

    ../liblinz-bde-perl_<version>_*

So then you can install it via:

    dpkg -i ../liblinz-bde-perl_*.deb

## Simple install

```shell
perl Build.PL
./Build install
```

## Advanced install options

The build system is using perl Module::Build. A full list of the building options are available run:

```shell
./Build help
```

A more complex example involving specific install directories could something like:

```shell
perl Build.PL --prefix=/usr/local
./Build install
```

## Dependencies

This package requires the [linz-bde-copy](https://github.com/linz/linz-bde-copy) programme to be
installed.

## Linting

Prerequisites: [Nix](https://nixos.org/download.html)

Run `nix-shell --pure --run 'pre-commit run --all-files'`.

## License

This program is released under the terms of the new BSD license. See the LICENSE file for more
information.

Copyright 2011 Crown copyright (c) Land Information New Zealand and the New Zealand Government.
