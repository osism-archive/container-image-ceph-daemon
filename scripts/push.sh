#!/usr/bin/env bash

# Available environment variables
#
# REPOSITORY
# VERSION

if [[ "$(docker images -q $REPOSITORY:$VERSION-centos-7-x86_64 2> /dev/null)" == "" ]]; then
    docker push "$REPOSITORY:$VERSION-centos-7-x86_64"
    docker rmi "$REPOSITORY:$VERSION-centos-7-x86_64"
fi
