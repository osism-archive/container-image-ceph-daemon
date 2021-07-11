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

if [[ "${VERSION}" == *"octopus"* || "${VERSION}" == *"pacific"* ]]; then
    DISTRIBUTION=centos-8
else
    DISTRIBUTION=centos-7
fi

if [[ "${VERSION}" == "latest" ]]; then
    tag="latest"
else
    tag="${VERSION}-${DISTRIBUTION}-x86_64"
fi

if DOCKER_CLI_EXPERIMENTAL=enabled docker manifest inspect "${REPOSITORY}:${VERSION}" > /dev/null; then
    echo "The image ${REPOSITORY}:${VERSION} already exists."
else
    docker tag "${REPOSITORY}:${tag}" "${REPOSITORY}:${VERSION}"
    docker push "${REPOSITORY}:${VERSION}"
fi

tag_release=$(echo "${VERSION}" | rev | cut -d- -f1 | rev)
docker tag "${REPOSITORY}:${tag}" "${REPOSITORY}:${tag_release}"
docker push "${REPOSITORY}:${tag_release}"
