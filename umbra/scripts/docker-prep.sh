#!/usr/bin/env bash

. $(dirname "$0")/../scripts/vars.sh

# If image with version is already loaded, return. Forward output to /dev/null
#/dev/null in Linux is a null device file. This will discard anything written to it, and will return EOF on reading.
echo "$IMAGENAME"
if docker inspect --type=image "$IMAGENAME" > /dev/null 2>&1; then
  echo "Image already exists."
  exit 0
fi
echo "Image $IMAGENAME does not exist, loading"
# Load the image
docker load -i $(dirname "$0")/../docker/umbra-docker-"${UMBRA_VERSION}".tar.gz
