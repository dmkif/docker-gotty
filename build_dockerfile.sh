#!/bin/bash
case $ARCH in
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

