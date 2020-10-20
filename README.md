# Python 3.8 Backport for Debian buster

The aim of this project is to provide a Python 3.8 backport to Debian buster. Packages are of course much better manageable then compiling the source from scratch.

Motivation for this project was the [deprecation of Python 3.7 support in Home Assistant](https://www.home-assistant.io/blog/2020/10/07/release-116/#python-37-deprecated). Support ends in version 0.118 which is scheduled for somewhere in December. While Debian bullseye will not be released anytime before April 2021. In the meantime, you can use this backport.

## Scope
The scope of this project is limited to backporting just Python 3.8 itself. So no defaults (which provide virtual packages so `python3` get's automatically linked to `python3.8`), no pip and no pip-packages. This version should be an extension to your system, but it's not meant to replace an existing Python installation.

### Virtual enviroment
To make the `venv` module work without backporting all pip-related packages, the `python3.8-venv` package depends on `python3-distutils` which is present in buster. After you have created your virtual enviroment you can then update pip itself and any packages as usual.

## Repository
You can download the packages in my repository at `deb.pascalroeleven.nl` by adding this line to your sources.list:
```sh
deb http://deb.pascalroeleven.nl/python3.8 buster-backports main
```
You should also add my PGP (which you can get from my website via https) to APT's sources keyring:
```sh
wget https://pascalroeleven.nl/deb-pascalroeleven.gpg
sudo apt-key add deb-pascalroeleven.gpg
```

## Support
Currently there is support for **`amd64`**, **`arm64`** and **`armhf`** architectures. The `amd64` packages are build natively while the `arm64` and `armhf` packages are crossbuilt. Testing is not possible while crossbuilding, so these packages did not undergo the same amount of testing as usual Debian packages do.

## Building the packages yourself
If you want to build the packages yourself, you can use the Dockerfile and the patches in this repository. Patches will be applied by the Dockerfile.

Two targets are supported: `native` and `crossbuild`. You should specify either of these:
```sh
docker build --target native .
```

When crossbuilding, you can specify the architecture by adding the `CROSSBUILD` build argument:
```sh
docker build --target crossbuild --build-arg CROSSBUILD=armhf .
```

You can also specify your name, email and changelog message when building which will then be added to the changelog.
```sh
docker build --target native --build-arg NAME="James Smith" --build-arg EMAIL="jamessmith@example.org" --build-arg CHANGE="Initial backport for buster" .
```

Building natively takes about 2 hours on a modern decent PC because of the extensive testing. Cross building takes about 30 minutes (but uses native binaries so requires the extra 2 hours the first time).
