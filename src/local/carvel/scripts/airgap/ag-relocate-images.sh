#!/usr/bin/env bash

function check_env() {
  eval ev='$'$1
  if [ "$ev" == "" ]; then
    echo "env var $1 not defined"
    exit 1
  fi
}

check_env INTERNAL_REGISTRY


#################################### cert-manager ######################################################
# TODO: YQ
export CM_1="quay.io/jetstack/cert-manager-cainjector:v1.11.1"
export CM_2="quay.io/jetstack/cert-manager-controller:v1.11.1"
export CM_3="quay.io/jetstack/cert-manager-webhook:v1.11.1"
export CM_4="quay.io/jetstack/cert-manager-acmesolver:v1.11.1"


export CM_1_INTERNAL="${INTERNAL_REGISTRY}/scdf/cert-manager/cert-manager-cainjector:v1.11.0"
export CM_2_INTERNAL="${INTERNAL_REGISTRY}/scdf/cert-manager/cert-manager-controller:v1.11.0"
export CM_3_INTERNAL="${INTERNAL_REGISTRY}/scdf/cert-manager/cert-manager-webhook:v1.11.0"
export CM_4_INTERNAL="${INTERNAL_REGISTRY}/scdf/cert-manager/cert-manager-acmesolver:v1.11.0"

docker pull $CM_1 --platform linux/amd64
docker tag $CM_1 $CM_1_INTERNAL
docker push $CM_1_INTERNAL
docker pull $CM_2 --platform linux/amd64
docker tag $CM_2 $CM_2_INTERNAL
docker push $CM_2_INTERNAL
docker pull $CM_3 --platform linux/amd64
docker tag $CM_3 $CM_3_INTERNAL
docker push $CM_3_INTERNAL
docker pull $CM_4 --platform linux/amd64
docker tag $CM_4 $CM_4_INTERNAL
docker push $CM_4_INTERNAL


sed -i -e "s~$CM_1~$CM_1_INTERNAL~g" ./manifests-download/cert-manager.yaml
sed -i -e "s~$CM_2~$CM_2_INTERNAL~g" ./manifests-download/cert-manager.yaml
sed -i -e "s~$CM_3~$CM_3_INTERNAL~g" ./manifests-download/cert-manager.yaml
sed -i -e "s~$CM_4~$CM_4_INTERNAL~g" ./manifests-download/cert-manager.yaml

#################################### secretgen-controller ######################################################

export SC_1="ghcr.io/carvel-dev/secretgen-controller@sha256:227567a3d3eacbaae4778ab1e58609a68f4bce5e099f2dd96597aa98c0708249"

export SC_1_INTERNAL="${INTERNAL_REGISTRY}/scdf/carvel-dev/secretgen-controller"

docker pull $SC_1 --platform linux/amd64
docker tag $SC_1 $SC_1_INTERNAL
docker push $SC_1_INTERNAL

SC_1_INTERNAL_SHA=$(docker inspect --format='{{index .RepoDigests 1}}' $SC_1_INTERNAL)

sed -i -e "s~$SC_1~$SC_1_INTERNAL_SHA~g" ./manifests-download/secretgen-controller.yaml


#################################### kapp-controller ######################################################


export KAP_1="ghcr.io/carvel-dev/kapp-controller@sha256:8011233b43a560ed74466cee4f66246046f81366b7695979b51e7b755ca32212"

export KAP_1_INTERNAL="${INTERNAL_REGISTRY}/scdf/carvel-dev/kapp-controller"

docker pull $KAP_1 --platform linux/amd64
docker tag $KAP_1 $KAP_1_INTERNAL
docker push $KAP_1_INTERNAL

KAP_1_INTERNAL_SHA=$(docker inspect --format='{{index .RepoDigests 1}}' $KAP_1_INTERNAL)

sed -i -e "s~$KAP_1~$KAP_1_INTERNAL_SHA~g" ./manifests-download/kapp-controller.yaml