#!/usr/bin/env bash

# Available environment variables
#
# BUILD_OPTS
# REPOSITORY
# VERSION

# Set default values

BUILD_OPTS=${BUILD_OPTS:-}
CREATED=$(date --rfc-3339=ns)
REVISION=$(git rev-parse --short HEAD)
VERSION=${VERSION:-latest}

# source: https://stackoverflow.com/questions/32113330/check-if-imagetag-combination-already-exists-on-docker-hub
function docker_tag_exists() {
    TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${TRAVIS_DOCKER_USERNAME}'", "password": "'${TRAVIS_DOCKER_PASSWORD}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)
    EXISTS=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/$1/tags/?page_size=10000 | jq -r "[.results | .[] | .name == \"$2\"] | any")
    test $EXISTS == true
}

docker_tag_exists $REPOSITORY $VERSION-centos-7-x86_64

if [[ $VERSION != "latest" && $? -eq 0 ]]; then
    echo "The image $REPOSITORY:$VERSION already exists."
else
    if [[ $VERSION == "latest" ]]; then
        tag="latest"
    else
        tag="$VERSION-centos-7-x86_64"
    fi

    docker build \
        --build-arg "TAG=$tag" \
        --tag "$REPOSITORY:$tag" \
        --label "org.opencontainers.image.created=$CREATED" \
        --label "org.opencontainers.image.revision=$REVISION" \
        --label "org.opencontainers.image.version=$VERSION" \
        --squash \
        $BUILD_OPTS .

    if [[ "$TRAVIS_PULL_REQUEST" == "false" && ( "$TRAVIS_BRANCH" == "master" || -n "$TRAVIS_TAG" ) ]]; then
        docker push "$REPOSITORY:$tag"
        docker rmi "$REPOSITORY:$tag"
    fi
fi
