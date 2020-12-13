FROM debian:buster-slim AS build-system
RUN echo 'deb http://deb.debian.org/debian bullseye main\n\
deb-src http://deb.debian.org/debian bullseye main'\
>> /etc/apt/sources.list
RUN echo 'Package: *\n\
Pin: release n=bullseye\n\
Pin-Priority: 1'\
> /etc/apt/preferences.d/99bullseye-testing
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential fakeroot devscripts
WORKDIR /usr/local/src
RUN apt-get source python3.8
RUN mv python3.8*/ python-source
WORKDIR python-source
ADD distutils-dep.diff .
RUN patch -p1 < distutils-dep.diff
ARG NAME
ARG EMAIL
ARG CHANGE
RUN dch --bpo "$CHANGE"

FROM build-system AS native
RUN mk-build-deps --install --tool 'apt-get -y --no-install-recommends'
RUN debuild -b -uc -us
RUN mkdir debs && mv ../*.deb debs

FROM build-system AS crossbuild
ARG CROSSBUILD
RUN [ ! -z "$CROSSBUILD" ]
RUN dpkg --add-architecture $CROSSBUILD
RUN apt-get update
COPY --from=native /usr/local/src/python-source/debs native-debs
RUN cd native-debs && apt-get install -y ./libpython3.8-minimal*.deb \
	./libpython3.8-stdlib*.deb \
	./libpython3.8_*.deb \
	./python3.8-minimal*.deb \
	./python3.8_*.deb
ADD crossbuild-dep.diff .
RUN patch -p1 < crossbuild-dep.diff
# For some reason mk-build-deps cannot install directly when cross-compiling
RUN mk-build-deps --arch $CROSSBUILD --host-arch $CROSSBUILD
RUN apt-get install -y ./python3.8-cross-build-deps*.deb
RUN DEB_BUILD_OPTIONS='nocheck nobench' debuild -b -uc -us -a$CROSSBUILD
RUN mkdir debs && mv ../*.deb debs
