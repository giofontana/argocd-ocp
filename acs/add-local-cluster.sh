#!/bin/bash

# 
# Parameters:
# 1. 
# 
# Pre-requisites:
# 1. "oc" cli is already installed
# 2. "oc" is already logged to the cluster with a cluster-admin user
# 3. ACS is up and running
#

# Example of Usage:
# ./add-local-cluster.sh 

echo "Downloading roxctl"
curl -O https://mirror.openshift.com/pub/rhacs/assets/latest/bin/Linux/roxctl
chmod +x roxctl

echo "Donwloaded latest version"
./roxctl version

acs_central_url="$(oc -n stackrox get route central -o jsonpath='{.spec.host}')"
acs_credentials=$(oc -n stackrox get secret central-htpasswd -o go-template='{{index .data "password" | base64decode}}')
api_token=$(curl -sk -u "admin:$acs_credentials" "https://$acs_central_url/v1/apitokens/generate" -d '{"name":"token name", "role": "Admin"}' | jq -r '.token')

export ROX_API_TOKEN=$api_token
export ROX_CENTRAL_ADDRESS="$acs_central_url:443"

./roxctl -e "$ROX_CENTRAL_ADDRESS" \
  central init-bundles generate local \
  --output-secrets cluster_init_bundle.yaml

oc apply -f cluster_init_bundle.yaml -n stackrox
oc apply -f deploy/secured-cluster.yaml -n stackrox
