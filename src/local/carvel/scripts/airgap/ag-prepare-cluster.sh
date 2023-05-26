#!/usr/bin/env bash
function check_env() {
  eval ev='$'$1
  if [ "$ev" == "" ]; then
    echo "env var $1 not defined"
    exit 1
  fi
}

function create_secret() {
  echo "Create docker-registry secret $1 for $2 username=$3 in namespace=$5"
  kubectl create secret docker-registry "$1" \
    --docker-server="$2" \
    --docker-username="$3" \
    --docker-password="$4" \
    --namespace "$5"
}

SCDIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
check_env INTERNAL_REGISTRY
#check_env INTERNAL_REGISTRY_SECRET_YAML

echo "Creating secretgen-controller namespace"
kubectl create namespace secretgen-controller --dry-run=client -o yaml | kubectl apply -f -
#kubectl apply -f $INTERNAL_REGISTRY_SECRET_YAML -n secretgen-controller
#kubectl patch sa default -n secretgen-controller -p '"imagePullSecrets": [{"name": "reg-creds-dev-registry" }]'

echo "Deploying secretgen-controller"
kapp deploy --yes --wait --wait-check-interval 10s --app secretgen-controller --file manifests-download/secretgen-controller.yaml
#kapp deploy --yes --wait --wait-check-interval 10s --app secretgen-controller --file <(ytt template -f manifests-download/secretgen-controller.yaml -f  ag-secret-overlay.yaml)
echo "Deployed secretgen-controller"


echo "Creating cert-manager namespace"
kubectl create namespace cert-manager --dry-run=client -o yaml | kubectl apply -f -
#kubectl apply -f $INTERNAL_REGISTRY_SECRET_YAML -n cert-manager
#kubectl patch sa default -n secretgen-controller -p '"imagePullSecrets": [{"name": "reg-creds-dev-registry" }]'

echo "Deploying cert-manager"
kapp deploy --yes --wait --wait-check-interval 10s --app cert-manager --file manifests-download/cert-manager.yaml
#kapp deploy --yes --wait --wait-check-interval 10s --app cert-manager --file  <(ytt template -f manifests-download/cert-manager.yaml -f  ag-secret-overlay.yaml)
echo "Deployed cert-manager"


echo "Creating kapp-controller namespace"
kubectl create namespace kapp-controller --dry-run=client -o yaml | kubectl apply -f -
#kubectl apply -f $INTERNAL_REGISTRY_SECRET_YAML -n kapp-controller
#kubectl patch sa default -n kapp-controller -p '"imagePullSecrets": [{"name": "reg-creds-dev-registry" }]'

echo "Deploying kapp-controller"
kapp deploy --yes --wait --wait-check-interval 10s --app kapp-controller --file manifests-download/kapp-controller.yaml
#kapp deploy --yes --wait --wait-check-interval 10s --app kapp-controller --file <(ytt template -f manifests-download/kapp-controller.yaml -f  ag-secret-overlay.yaml)
echo "Deployed kapp-controller"