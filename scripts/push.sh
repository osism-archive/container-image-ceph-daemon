#!/usr/bin/env bash

# Available environment variables
#
# REPOSITORY
# VERSION

docker push "$REPOSITORY:$VERSION-centos-7-x86_64"
docker rmi "$REPOSITORY:$VERSION-centos-7-x86_64"
