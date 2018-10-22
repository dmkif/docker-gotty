#!/bin/bash
#Update Repository and install requirements
sudo apt-get update
sudo apt-get -y install binfmt-support build-essential qemu
sudo cp -r qemu-user-static/* /usr/ -v

#Update Docker cli to enable manifest commmand
sudo cp /usr/bin/docker /usr/bin/docker-cli.bak
sudo curl -fsSL https://github.com/clnperez/cli/releases/download/1.0/docker-linux-amd64 -o /usr/bin/docker
echo "{\"experimental\":true}" | sudo tee /etc/docker/daemon.json
sudo service docker restart

#Repair binfmt-support
case $ARCH in
    i386) qemu_arch=$ARCH 
          go_arch="386"
          ;;
    amd64) qemu_arch="x86_64" 
           go_arch=$ARCH
          ;;
    arm32v7) qemu_arch="arm" 
             go_arch="arm"
          ;;
    arm64v8) qemu_arch="aarch64" 
             go_arch="arm64"
          ;;
    ppc64el) qemu_arch="ppc64le" 
             go_arch="ppc64le"
          ;;
    *) qemu_arch=$ARCH
       go_arch=$ARCH
       ;;
esac

# repair binfmt-support
git clone https://github.com/computermouth/qemu-static-conf.git
sudo mkdir -p /lib/binfmt.d
sudo cp qemu-static-conf/*.conf /lib/binfmt.d/

# download latest qemu-static-files
wget -N https://github.com/multiarch/qemu-user-static/releases/download/v3.0.0/x86_64_qemu-${qemu_arch}-static.tar.gz
tar -xvf x86_64_qemu-${qemu_arch}-static.tar.gz

sudo /etc/init.d/binfmt-support restart
sudo cat /proc/sys/fs/binfmt_misc/status
docker run --rm --privileged multiarch/qemu-user-static:register --reset

