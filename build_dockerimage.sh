#!/bin/bash
#Export TAG
if [ $TRAVIS_BRANCH = "master" ] 
then 
    export TAG="latest"
else 
    export TAG=$TRAVIS_BRANCH
fi
echo "Current Branch: $TRAVIS_BRANCH"
echo "Set TAG to $TAG"

#Build dockerimage 
docker build --compress --squash -t "${REPO}:${ARCH}-${TAG}" -f Dockerfile."${ARCH}" .
