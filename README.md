# ArgoCD Manifests for OpenShift Tools

This repo contains manifests to deploy the following tools on any OpenShift cluster which has **ArgoCD** running.

**[Advanced Cluster Management](#acm---advanced-cluster-management)**<br>
**[Advanced Cluster Security (StackRox)](#acs---advanced-cluster-security)**<br>
**[Quay](#quay)**<br>

## Usage

To use the manifests here with ArgoCD follow the instructions below. Keep in mind that the following permission need to be set before usage, to give ArgoCD's required permissions:

```
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller
```

----

### ACM - Advanced Cluster Management

This folder contains two ArgoCD manifests:
- deploy-operator.yaml: This file creates the `acm-operator` application on ArgoCD, which is responsible to deploy the ACM operator.
- deploy-acm.yaml: This file creates the `acm-app` application on ArgoCD, which is responsible to deploy the ACM MultiClusterHub instance and install ACM application.

To deploy ACM using it you should apply both manifests:

```
oc apply -f ./acm/deploy-operator.yaml
oc apply -f ./acm/deploy-acm.yaml
```

However, the following are pre-requisites to use it:
1. A namespace named `openshift-advanced-cluster-mgmt` must exists already;
2. A secret named `acm-pullsecret` which contains the cluster's pull-secret must exists in the namespace `openshift-advanced-cluster-mgmt`.

Optionally you can use the shell script `./acm/deploy-acm-with-argo.sh` for that. To use this shell script you must have `oc` running and logged to the cluster with a `cluster-admin` user. Example of Usage:

```
./acm/deploy-acm-with-argo.sh '<PULL_SECRET>'
```

----

### ACS - Advanced Cluster Security

This folder contains two ArgoCD manifests:
- deploy-operator.yaml: This file creates the `acs-operator` application on ArgoCD, which is responsible to deploy the ACS operator.
- deploy-acs.yaml: This file creates the `acs-app` application on ArgoCD, which is responsible to deploy the ACS Central instance and install Stackrox.

To deploy ACS using it you should apply both manifests:

```
oc apply -f ./acs/deploy-operator.yaml
oc apply -f ./acs/deploy-acs.yaml
```

Optionally you can use the shell script `./acs/deploy-acs-with-argo.sh` for that. To use this shell script you must have `oc` running and logged to the cluster with a `cluster-admin` user.

----

### Quay

This folder contains three ArgoCD manifests:
- deploy-operators.yaml: This file creates the `quay-operators` application on ArgoCD, which is responsible to deploy the Quay and ODF (aka OCS) operators.
- deploy-noobaa.yaml: This file creates the `quay-noobaa` application on ArgoCD, which is responsible to deploy `Noobaa` and a `BackingStore` using a PV to be used as the S3 backend for Quay.
- deploy-quay.yaml: This file creates the `quay` application on ArgoCD, which is responsible to deploy the QuayRegistry instance and install Quay.

To deploy ACS using it you should apply both manifests:

```
oc apply -f ./quay/deploy-operator.yaml
oc apply -f ./quay/deploy-noobaa.yaml
oc apply -f ./quay/deploy-quay.yaml
```

Optionally you can use the shell script `./quay/deploy-quay-with-argo.sh` for that. To use this shell script you must have `oc` running and logged to the cluster with a `cluster-admin` user.
