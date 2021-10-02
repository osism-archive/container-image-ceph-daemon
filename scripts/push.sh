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

tag_version=$(echo "${VERSION:1}" | cut -d- -f1)
if skopeo inspect --creds "${DOCKER_USERNAME}:${DOCKER_PASSWORD}" "docker://${REPOSITORY}:${tag_version}" > /dev/null; then
    echo "The image ${REPOSITORY}:${tag_version} already exists."
else
    buildah tag "${REPOSITORY}:${tag}" "${REPOSITORY}:${tag_version}"
    buildah push "${REPOSITORY}:${tag_version}"
fi

tag_release=$(echo "${VERSION}" | rev | cut -d- -f1 | rev)
buildah tag "${REPOSITORY}:${tag}" "${REPOSITORY}:${tag_release}"
buildah push "${REPOSITORY}:${tag_release}"
