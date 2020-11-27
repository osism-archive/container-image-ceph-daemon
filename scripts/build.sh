#!/usr/bin/env bash

# Available environment variables
#
# BUILD_OPTS
# REPOSITORY
# VERSION

# Set default values

BUILD_OPTS=${BUILD_OPTS:-}
CREATED=$(date --rfc-3339=ns)
REPOSITORY=${REPOSITORY:-osism/ceph-daemon}
REVISION=$(git rev-parse --short HEAD)
VERSION=${VERSION:-latest}

if [[ $VERSION == *"octopus"* ]]; then
    DISTRIBUTION=centos-8
else
    DISTRIBUTION=centos-7
fi

if DOCKER_CLI_EXPERIMENTAL=enabled docker manifest inspect $REPOSITORY:$$VERSION-$DISTRIBUTION-x86_64>/dev/null; then
    echo "The image $REPOSITORY:$VERSION already exists."
else
    if [[ $VERSION == "latest" ]]; then
        version="latest"
    else
        version="$VERSION-$DISTRIBUTION-x86_64"
    fi

    docker build \
        --build-arg "VERSION=$version" \
        --tag "$REPOSITORY:$version" \
        --label "org.opencontainers.image.created=$CREATED" \
        --label "org.opencontainers.image.revision=$REVISION" \
        --label "org.opencontainers.image.version=$VERSION" \
        $BUILD_OPTS .
fi
