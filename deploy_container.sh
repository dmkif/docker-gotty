#!/bin/bash
#Login to DockerHub 
#Export TAG
export TAG=$TRAVIS_BRANCH

echo "$DOCKER_PASSWORT" | docker login -u "$DOCKER_USER" --password-stdin
#if branch is master, tag image as latest and push it also with build-number
if [ $TRAVIS_BRANCH = "master" ]
 then
   export TAG="latest"
fi 

docker tag  "$REPO:$ARCH-$TAG" "$REPO:$ARCH-$TRAVIS_BUILD_NUMBER"
docker push "$REPO:$ARCH-$TRAVIS_BUILD_NUMBER"
docker push "$REPO:$ARCH-$TAG"

docker logout
