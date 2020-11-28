#!/usr/bin/env bash

# Available environment variables
#
# DOCKER_REGISTRY
# REPOSITORY
# VERSION

# Set default values

CREATED=$(date --rfc-3339=ns)
DOCKER_REGISTRY=${DOCKER_REGISTRY:-quay.io}
REPOSITORY=${REPOSITORY:-osism/ceph-daemon}
REVISION=$(git rev-parse --short HEAD)
VERSION=${VERSION:-latest}

REPOSITORY="${DOCKER_REGISTRY}/${REPOSITORY}"

if [[ "${VERSION}" == *"octopus"* ]]; then
    DISTRIBUTION=centos-8
else
    DISTRIBUTION=centos-7
fi

if [[ "${VERSION}" == "latest" ]]; then
    version="latest"
else
    version="${VERSION}-${DISTRIBUTION}-x86_64"
fi

docker build \
    --build-arg "VERSION=${version}" \
    --tag "${REPOSITORY}:${version}" \
    --label "org.opencontainers.image.created=${CREATED}" \
    --label "org.opencontainers.image.revision=${REVISION}" \
    --label "org.opencontainers.image.version=${VERSION}" \
    .
