#!/usr/bin/env bash

# Available environment variables
#
# BUILD_OPTS
# REPOSITORY
# VERSION

# Set default values

BUILD_OPTS=${BUILD_OPTS:-}
HASH_REPOSITORY=$(git rev-parse --short HEAD)

# source: https://stackoverflow.com/questions/32113330/check-if-imagetag-combination-already-exists-on-docker-hub
function docker_tag_exists() {
    TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${TRAVIS_DOCKER_USERNAME}'", "password": "'${TRAVIS_DOCKER_PASSWORD}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)
    EXISTS=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/$1/tags/?page_size=10000 | jq -r "[.results | .[] | .name == \"$2\"] | any")
    test $EXISTS == true
}

if docker_tag_exists $REPOSITORY $VERSION-centos-7-x86_64; then
    echo "The image $REPOSITORY:$VERSION already exists."
else
    docker build \
        --build-arg "VERSION=$VERSION" \
        --label "io.osism.${REPOSITORY#osism/}=$HASH_REPOSITORY" \
        --tag "$REPOSITORY:$VERSION-centos-7-x86_64" \
        --squash \
        $BUILD_OPTS .
fi
