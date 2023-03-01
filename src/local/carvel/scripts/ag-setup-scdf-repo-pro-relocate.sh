#!/usr/bin/env bash
function check_env() {
  eval ev='$'$1
  if [ "$ev" == "" ]; then
    echo "env var $1 not defined"
    exit 1
  fi
}



PACKAGE_VERSION=1.5.2-SNAPSHOT
PACKAGE_NAME=scdfpro.tanzu.vmware.com
REGISTRY=dev.registry.pivotal.io




check_env TANZU_DOCKER_USERNAME
check_env TANZU_DOCKER_PASSWORD

docker login $REGISTRY -u $TANZU_DOCKER_USERNAME -p $TANZU_DOCKER_PASSWORD

check_env DOCKER_HUB_USERNAME
check_env DOCKER_HUB_PASSWORD

docker login index.docker.io -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD

check_env INTERNAL_REGISTRY
# docker login $INTERNAL_REGISTRY

ARTIFACT_NAME="scdf-pro-repo"
REPO_NAME="p-scdf-for-kubernetes"
TARGET_REPO_NAME="scdf"

imgpkg copy -b $REGISTRY/$REPO_NAME/$ARTIFACT_NAME:$PACKAGE_VERSION --to-tar=$ARTIFACT_NAME-$PACKAGE_VERSION.tar



imgpkg copy --tar $ARTIFACT_NAME-$PACKAGE_VERSION.tar --to-repo=$INTERNAL_REGISTRY/$TARGET_REPO_NAME/$ARTIFACT_NAME
