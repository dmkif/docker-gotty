#!/bin/bash
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

sed s/"@@ARCH@@"/"$ARCH"/g Dockerfile > Dockerfile.$ARCH
sed -i s/"@@QEMU_ARCH@@"/"$qemu_arch"/g Dockerfile.$ARCH
sed -i s/"@@GO_ARCH@@"/"$go_arch"/g Dockerfile.$ARCH

