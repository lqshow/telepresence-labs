#!/usr/bin/env bash

if [ ! -d ".debug" ]; then
  echo "This script expects to be run in the root directory of the project."
  exit 1
fi

ARCH=amd64
IMAGE_REGISTRY=lqshow
IMAGE_NAME=docker-run-$ARCH
VERSION=`git describe --always --dirty`
IMAGE=$IMAGE_REGISTRY/$IMAGE_NAME

telepresence --mount=/tmp/known \
    --deployment telepresence-k8s-0-109 \
    --method container \
    --docker-run \
    -p 3000:3000 \
    --rm \
    -it \
    -v "$(pwd)":/data/project \
    -v /tmp/known/var/run/secrets:/var/run/secrets \
    --env-file $(pwd)/.env \
    $IMAGE:$VERSION \
    /bin/sh
