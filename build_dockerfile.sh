#!/bin/bash
if [ "$ARCH" = "amd64" ]
  then
    sed s/"@@ARCH_2@@"/"x86_64"/g Dockerfile > Dockerfile.$ARCH
  elif [ "$ARCH" = "arm64v8" ]
  then
    sed s/"@@ARCH_2@@"/"aarch64"/g Dockerfile > Dockerfile.$ARCH
  else
    sed s/"@@ARCH_2@@"/"@@ARCH@@"/g Dockerfile > Dockerfile.$ARCH
fi 
sed -i s/"@@ARCH@@"/"$ARCH"/g Dockerfile.$ARCH
