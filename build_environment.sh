#!/bin/sh
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
git clone https://github.com/computermouth/qemu-static-conf.git
sudo mkdir -p /lib/binfmt.d
sudo cp qemu-static-conf/*.conf /lib/binfmt.d/
sudo /etc/init.d/binfmt-support restart
sudo cat /proc/sys/fs/binfmt_misc/status
docker run --rm --privileged multiarch/qemu-user-static:register --reset