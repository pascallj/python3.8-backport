# Python 3.8 Backport for Debian buster
>***NOTE**: This git repository is now archived because Debian 11 bullseye has been released. The packages repository for Debian will still be available for some time depending on its usage.*

The aim of this project is to provide a Python 3.8 backport to Debian buster. Packages are of course much better manageable than compiling the source from scratch.

Motivation for this project was the [deprecation of Python 3.7 support in Home Assistant 0.116](https://www.home-assistant.io/blog/2020/10/07/release-116/#python-37-deprecated). Support ended in version 2021.2 which was released on February 3, 2021. Debian bullseye (which will contain Python 3.9) will not be released anytime before April 2021. In the meantime, you can use this backport.

More information about the use of this packages/repository for Home Assistant can be found on a [Home Assistant Community post](https://community.home-assistant.io/t/home-assistant-core-python-3-8-backport-for-debian-buster/234859/) I've written.

## Scope
The scope of this project is limited to backporting just Python 3.8 itself. So no defaults (which provide virtual packages so `python3` get's automatically linked to `python3.8`) and no precompiled pip-packages or wheels. Therefore it can coexist with your regular Python (3.7) installation without any interference and still being simple to maintain. It's main use is for in virtual environments where you can use pip to compile and install any packages you desire. It does provide all the packages and dependencies needed to create a Python 3.8 virtual environment.

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

If you want to build against the debian `sid` branch instead of `bullseye`, you can specify this with the `DEV=yes` build argument:
```sh
docker build --target native --build-arg DEV=yes .
```

Building natively takes about 2 hours on a modern decent PC because of the extensive testing. Cross building takes about 30 minutes (but uses native binaries so requires the extra 2 hours the first time).
