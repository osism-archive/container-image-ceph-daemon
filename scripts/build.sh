#!/usr/bin/env bash
set -x

# Available environment variables
#
# BUILD_OPTS
# REPOSITORY
# VERSION

# Set default values

BUILD_OPTS=${BUILD_OPTS:-}
HASH_REPOSITORY=$(git rev-parse --short HEAD)

docker build \
    --build-arg "VERSION=$VERSION" \
    --label "io.osism.${REPOSITORY#osism/}=$HASH_REPOSITORY" \
    --tag "$REPOSITORY:$VERSION-centos-7-x86_64" \
    --squash \
    $BUILD_OPTS .
