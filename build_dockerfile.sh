#!/bin/bash
case $ARCH in
    amd64) goarch="x86_64"
           ;;
    i386) goarch="386" 
          ;;
    armhf) goarch="arm"
           ;;
    ppc64el) goarch="ppc64le"
             ;;
    arm64v8) goarch="aarch64"
             ;;
    *) goarch=$ARCH
       ;;
esac

sed s/"@@ARCH_2@@"/"$goarch"/g Dockerfile > Dockerfile.$ARCH
sed -i s/"@@ARCH@@"/"$ARCH"/g Dockerfile.$ARCH

