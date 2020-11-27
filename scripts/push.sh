#!/usr/bin/env bash

# Available environment variables
#
# DOCKER_REGISTRY
# REPOSITORY
# VERSION

# Set default values

DOCKER_REGISTRY=${DOCKER_REGISTRY:-quay.io}
REPOSITORY=${REPOSITORY:-osism/ceph-daemon}
VERSION=${VERSION:-latest}

REPOSITORY="${DOCKER_REGISTRY}/${REPOSITORY}"

if [[ "${VERSION}" == *"octopus"* ]]; then
    DISTRIBUTION=centos-8
else
    DISTRIBUTION=centos-7
fi

if [[ "${VERSION}" == "latest" ]]; then
    tag="latest"
else
    tag="${VERSION}-${DISTRIBUTION}-x86_64"
fi

docker push "${REPOSITORY}:${tag}"
