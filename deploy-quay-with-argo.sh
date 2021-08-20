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


echo "Deploying Quay using ArgoCD..."
./argo-app-runner.sh quay 'https://github.com/giofontana/argocd-ocp.git' 'quay/gitops' HEAD