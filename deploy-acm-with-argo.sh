#!/bin/bash

# 
# Pre-requisites:
# 1. "oc" cli is already installed
# 2. "oc" is already logged to the cluster with a cluster-admin user
# 3. ArgoCD is installed in openshift-gitops namespace
#
# Example of Usage:
# ./deploy-acm-with-argo.sh


echo "Deploying ACM using ArgoCD..."
./argo-app-runner.sh acm 'https://github.com/giofontana/argocd-ocp.git' 'acm/gitops' HEAD
