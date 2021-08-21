
#!/bin/bash

# 
# Pre-requisites:
# 1. "oc" cli is already installed
# 2. "oc" is already logged to the cluster with a cluster-admin user
# 3. ArgoCD is installed in openshift-gitops namespace
#
# Example of Usage:
# ./argo-app-runner.sh <app-name> <git-repo> <git-path> <git-revision> <timeout>

app_name="$1"
git_repo="$2"
git_path="$3"
git_rev="$4"
timeout="${5:-15}"

echo "Creating Application $app_name on ArgoCD from $git_repo/$git_path - Revision $git_rev"

cat <<EOF | oc apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: $app_name
  namespace: openshift-gitops
spec:
  project: default
  source:
    repoURL: "$git_repo"
    path: $git_path
    targetRevision: $git_rev
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF

echo "Waiting for application $app_name to be 'Succeeded' on ArgoCD (timeout $timeout mins)"

sleep 10
TIMEOUT=0 
status=`oc get application $app_name -n openshift-gitops -o jsonpath='{.status.operationState.phase}'`
while [ "$status" != "Succeeded" ]; do
  echo "Application $app_name still being deployed. Waiting one more minute..."
  sleep 60
  if [ $TIMEOUT -gt 20 ]; then #20 MINUTES TIMEOUT
    echo "Timeout reached... Check the status of the deployment on ArgoCD."
    exit 1
  fi
  TIMEOUT=$(($TIMEOUT+1))
  status=`oc get application $app_name -n openshift-gitops -o jsonpath='{.status.operationState.phase}'`
done

echo "Application $app_name is 'Succeeded'"