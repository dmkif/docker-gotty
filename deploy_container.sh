#!/bin/sh
#Login to DockerHub 
echo "$DOCKER_PASSWORT" | docker login -u "$DOCKER_USER" --password-stdin
#if branch is master tag image as latest and push it
if [ "$TRAVIS_PULL_REQUEST" = "false" ] && [ "$TRAVIS_BRANCH" = "master" ]
 then
   docker tag  "$REPO-$ARCH:$TAG" "$REPO-$ARCH:$TRAVIS_BUILD_NUMBER"
   docker push "$REPO-$ARCH:$TRAVIS_BUILD_NUMBER"
fi 
docker push "$REPO-$ARCH:$TAG"

docker logout
