#!/bin/bash

# 
# Pre-requisites:
# 1. "oc" cli is already installed
# 2. "oc" is already logged to the cluster with a cluster-admin user
# 3. ArgoCD is installed in openshift-gitops namespace
#
# Example of Usage:
# ./deploy-acs-with-argo.sh

echo "Deploying ACS ..."
oc apply -f deploy-operator.yaml
oc apply -f deploy-acs.yaml

sleep 60
TIMEOUT=0 
status=$(oc get Central stackrox-central-services -n stackrox -o jsonpath='{.status.conditions[0].type}')
while [ "$status" != "Deployed" ]; do
  echo "It still being deployed. Waiting one more minute..."
  sleep 60
  if [ $TIMEOUT -gt 15 ]; then #15 MINUTES TIMEOUT
    echo "Timeout reached... Check the status of the deployment on OpenShift."
    exit 1
  fi
  TIMEOUT=$(($TIMEOUT+1))
  status=$(oc get Central stackrox-central-services -n stackrox -o jsonpath='{.status.conditions[0].type}')
done

central_password=$(oc get Central stackrox-central-services -n stackrox -o jsonpath='{.status.central.adminPassword.info}')

echo "Deployment Finished! $central_password"