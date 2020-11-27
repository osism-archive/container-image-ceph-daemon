#!/usr/bin/env bash

# Available environment variables
#
# REPOSITORY
# VERSION

# Set default values

REPOSITORY=${REPOSITORY:-osism/ceph-daemon}
VERSION=${VERSION:-latest}

if [[ $VERSION == *"octopus"* ]]; then
    DISTRIBUTION=centos-8
else
    DISTRIBUTION=centos-7
fi

if [[ $VERSION == "latest" ]]; then
    tag="latest"
else
    tag="$VERSION-$DISTRIBUTION-x86_64"
fi

docker push "$REPOSITORY:$tag"
