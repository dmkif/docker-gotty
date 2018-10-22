#!/bin/bash
set -e;
#Login to DockerHub 
echo "$DOCKER_PASSWORT" | docker login -u "$DOCKER_USER" --password-stdin
manifestname="$REPO:$PUBTAG"
manifeststring=$manifestname

for platform in $ARCH
do
    echo "Performing Architecture: ${platform}";
    #get latest image
    echo "Pulling latest Image from Dockerhub with tag ${REPO}:${platform}-${TRAVIS_BUILD_NUMBER}"
    docker pull $REPO:$platform-$TRAVIS_BUILD_NUMBER
   #build manifest
   manifeststring="$manifeststring $REPO:$platform-$TRAVIS_BUILD_NUMBER";
done;

echo "Generating manifest with String: ${manifeststring}"
docker manifest create $manifeststring;

#clean platform var
platform="";
for platform in $ARCH
do
#annotate manifest with correct arch
echo "platform: $platform"
case $platform in
    i386) qemu_arch=$platform 
          go_arch="386"
          ;;
    amd64) qemu_arch="x86_64" 
           go_arch=$platform
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
    *) qemu_arch=$platform
       go_arch=$platform
       ;;
esac

    echo "Annotating Manifest with ARCH:${go_arch} NAME:${manifestname} $REPO:$platform-$TRAVIS_BUILD_NUMBER";   
    docker manifest annotate --arch=$go_arch $manifestname $REPO:$platform-$TRAVIS_BUILD_NUMBER;
done;

echo "Created manifest:"
docker manifest inspect "${REPO}:${PUBTAG}"
echo "Push manifest:"
docker manifest push -p "${REPO}:${PUBTAG}"
docker logout
