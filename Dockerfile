FROM @@ARCH@@/golang:stretch
MAINTAINER Daniel Mulzer <daniel.mulzer@fau.de>
COPY ./qemu-user-static/qemu-@@ARCH@@-static /usr/bin/qemu-@@ARCH@@-static
# Install packages necessary to run EAP
USER root
RUN apt-get update && \
    apt-get -y install curl tar xterm libncurses5-dev libgmp-dev && \
    apt-get -y autoremove && \
    apt-get -y clean && \ 
    rm -rf /var/lib/apt/lists/*
    

# Set the working directory to jboss' user home directory
WORKDIR /tmp/

#download and install berkley-db in right version
RUN apt-get update && \
    apt-get -y install autoconf build-essential checkinstall && \
    curl -sLk https://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz | tar xz && \
    cd db-4.8.30.NC/build_unix && \
    ../dist/configure --enable-cxx --prefix=/usr && make -j8 && \
    checkinstall --fstrans=no --pkgversion=4.8.30 --pkgname=libdb4.8-dev --nodoc -y && \
    cd /tmp/ && \
    rm -rf * && \
    apt-get -y --purge autoremove autoconf build-essential checkinstall && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*


# download and install open-cobol for depencies (libcob >= 4.0)
RUN apt-get update && \
    apt-get -y install autoconf build-essential && \
    curl -sLk https://sourceforge.net/projects/open-cobol/files/gnu-cobol/3.0/gnucobol-3.0-rc1.tar.gz | tar xz && \
    cd gnucobol-3.0-rc1 && ./configure && make && make install && ldconfig && cd /tmp/ && rm -rf * && \
    apt-get -y --purge autoremove autoconf build-essential && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)
RUN groupadd -r gotty -g 1000 && useradd -u 1000 -r -g gotty -m -d /opt/gotty -s /sbin/nologin -c "Gotty user" gotty && \
    chmod 755 /opt/gotty

WORKDIR /opt/gotty
RUN go get github.com/yudai/gotty

USER gotty

EXPOSE 8081

# Execute Gotty
ENTRYPOINT ["gotty"]
#Default arguments ...
CMD ["--port","8081","/bin/bash"]
