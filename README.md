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

> **_NOTE:_** To use the bash scripts you should login to the cluster with a cluster-admin user and also have ArgoCD installed on openshift-gitops namespace.

----

### ACM - Advanced Cluster Management

This folder contains two folders:
- gitops/operator: This folder contains the manifests responsible to create ACM namespace, deploy the ACM operator and create the pull-secret in ACM namespace (from openshift-config namespace).
- gitops/deploy: This folder contains the manifests responsible to deploy the ACM MultiClusterHub instance and install ACM application.

To deploy ACM using it, login with a cluster-admin user and run the bash script `deploy-acm-with-argo.sh`. Example:

```
oc login https://api.<ocp-domain>:6443 -u admin -p XXXX
./deploy-acm-with-argo.sh
```

----

### ACS - Advanced Cluster Security

This folder contains three folders:
- gitops/operator: This folder contains the manifests responsible to install ACS operator.
- gitops/deploy: This folder contains the manifests responsible to deploy the ACS Central and SecuredCluster instances to install ACS central an register OCP local cluster as a SecuredCluster (managed cluster).
- gitops/sample-app: This folder contains the manifests responsible to deploy two sample applications on `stackrox-sample` namespace.

To deploy ACS using it, login with a cluster-admin user and run the bash script `deploy-acs-with-argo.sh`. Example:

```
oc login https://api.<ocp-domain>:6443 -u admin -p XXXX
./deploy-acs-with-argo.sh
```

----

### Quay

This folder contains three folders:
- gitops/operators: This folder contains the manifests responsible to install Quay and OpenShift Data Foundation (aka OpenShift Container Storage) operators. The OpenShift Data Foundation operator is used to deploy Noobaa, which will be the S3 storage provider for Quay.
- gitops/noobaa: This folder contains the manifests responsible to deploy Noobaa, to provide an S3 storage provider for Quay.
- gitops/deploy: This folder contains the manifests responsible to deploy `QuayRegistry` instance and installs Quay.

To deploy Quay using it, login with a cluster-admin user and run the bash script `deploy-quay-with-argo.sh`. Example:

```
oc login https://api.<ocp-domain>:6443 -u admin -p XXXX
./deploy-quay-with-argo.sh
```
