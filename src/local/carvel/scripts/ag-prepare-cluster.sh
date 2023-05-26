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

echo "Creating secretgen-controller namespace"
kubectl create namespace secretgen-controller --dry-run=client -o yaml | kubectl apply -f -

check_env INTERNAL_REGISTRY
check_env INTERNAL_REGISTRY_USERNAME
check_env INTERNAL_REGISTRY_PASSWORD
check_env INTERNAL_REGISTRY_SECRET_YAML



# create_secret reg-creds-dev-registry $INTERNAL_REGISTRY "$INTERNAL_REGISTRY_USERNAME" "$INTERNAL_REGISTRY_PASSWORD" secretgen-controller
# kubectl create sa secretgen-controller-sa -n secretgen-controller --dry-run=client -o yaml | kubectl apply -f -
# kubectl patch sa secretgen-controller-sa -n secretgen-controller -p '"imagePullSecrets": [{"name": "reg-creds-dev-registry" }]'
kubectl apply -f $INTERNAL_REGISTRY_SECRET_YAML -n secretgen-controller
kubectl patch sa default -n secretgen-controller -p '"imagePullSecrets": [{"name": "reg-creds-dev-registry" }]'

# echo "Annotating reg-creds-dev-registry for image-pull-secret"
# kubectl annotate secret reg-creds-dev-registry --namespace secretgen-controller  secretgen.carvel.dev/image-pull-secret=""


echo "Deploying secretgen-controller"
kapp deploy --yes --wait --wait-check-interval 10s --app secretgen-controller \
    --file <(ytt template -f manifests-download/secretgen-controller.yaml -f  ag-secret-overlay.yaml)
echo "Deployed secretgen-controller"
# kubectl apply -f "$SCDIR/ag-secret-gen-export.yml" --namespace secretgen-controller


echo "Creating cert-manager namespace"
kubectl create namespace cert-manager --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f $INTERNAL_REGISTRY_SECRET_YAML -n cert-manager
# create_secret reg-creds-dev-registry $INTERNAL_REGISTRY "$INTERNAL_REGISTRY_USERNAME" "$INTERNAL_REGISTRY_PASSWORD" cert-manager
kubectl patch sa default -n secretgen-controller -p '"imagePullSecrets": [{"name": "reg-creds-dev-registry" }]'

echo "Deploying cert-manager"
kapp deploy --yes --wait --wait-check-interval 10s --app cert-manager \
    --file  <(ytt template -f manifests-download/cert-manager.yaml -f  ag-secret-overlay.yaml) 
echo "Deployed cert-manager"

echo "Creating kapp-controller namespace"
kubectl create namespace kapp-controller --dry-run=client -o yaml | kubectl apply -f -
# create_secret reg-creds-dev-registry $INTERNAL_REGISTRY "$INTERNAL_REGISTRY_USERNAME" "$INTERNAL_REGISTRY_PASSWORD" kapp-controller
kubectl apply -f $INTERNAL_REGISTRY_SECRET_YAML -n kapp-controller
kubectl patch sa default -n kapp-controller -p '"imagePullSecrets": [{"name": "reg-creds-dev-registry" }]'
echo "Deploying kapp-controller"
kapp deploy --yes --wait --wait-check-interval 10s --app kapp-controller --file <(ytt template -f manifests-download/kapp-controller.yaml -f  ag-secret-overlay.yaml)
echo "Deployed kapp-controller"