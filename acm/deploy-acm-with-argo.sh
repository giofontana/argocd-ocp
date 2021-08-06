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
# ./deploy-acm-with-argo.sh '{"auths":{"cloud.openshift.com":{"auth":"b3B...}}}'


echo "Creating ACM Namespace ..."
oc create namespace openshift-advanced-cluster-mgmt

echo "Creating ACM Pull Secret ..."
echo "$1" > pull-secret.txt
oc create secret generic acm-pullsecret -n openshift-advanced-cluster-mgmt --from-file=.dockerconfigjson=pull-secret.txt --type=kubernetes.io/dockerconfigjson
rm -f pull-secret.txt

echo "Deploying ACM ..."
oc apply -f deploy-operator.yaml
oc apply -f deploy-acm.yaml

TIMEOUT=0 
mch_status=$(oc get MultiClusterHub multiclusterhub -n openshift-advanced-cluster-mgmt -o jsonpath='{.status.phase}')
while [ "$mch_status" != "Running" ]; do
  echo "MultiClusterHub still being deployed. Waiting one more minute..."
  sleep 60
  if [ $TIMEOUT -gt 30 ]; then #30 MINUTES TIMEOUT
    echo "Timeout reached... Check the status of the deployment on OpenShift."
    exit 1
  fi
  TIMEOUT=$(($TIMEOUT+1))
  mch_status=$(oc get MultiClusterHub multiclusterhub -n openshift-advanced-cluster-mgmt -o jsonpath='{.status.phase}')
done

echo "ACM Deployment Finished"