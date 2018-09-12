#!/bin/bash
#Export TAG
if [ $TRAVIS_BRANCH = "master" ] 
then 
	export TAG="latest"
else 
	export TAG=$TRAVIS_BRANCH
fi
echo "Set TAG to $TAG"

docker images "${REPO}:${ARCH}-${TAG}"
docker run --entrypoint "uname" -t "${REPO}:${ARCH}-${TAG}" -a
