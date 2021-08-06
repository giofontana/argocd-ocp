#!/bin/bash

# Parameters
# 1. PULL SECRET
# 
# Pre-requisites:
# 1. "oc" cli is already installed
# 2. "oc" is already logged to the cluster with a cluster-admin user
# 3. ArgoCD is installed in openshift-gitops namespace
#
# Example of Usage:
# ./deploy-quay-with-argo.sh


echo "Deploying Quay using Argo ..."
oc apply -f deploy-quay.yaml

TIMEOUT=0 
status=$(oc get quayregistry quay-registry -n openshift-operators -o jsonpath='{.status.conditions[0].type}')
while [ "$status" != "Available" ]; do
  echo "It still being deployed. Waiting one more minute..."
  sleep 60
  if [ $TIMEOUT -gt 15 ]; then #15 MINUTES TIMEOUT
    echo "Timeout reached... Check the status of ACM deployment on OpenShift."
    exit 1
  fi
  TIMEOUT=$(($TIMEOUT+1))
  status=$(oc get quayregistry quay-registry -n openshift-operators -o jsonpath='{.status.conditions[0].type}')
done

echo "Deployment Finished"