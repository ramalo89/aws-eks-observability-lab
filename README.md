# AWS EKS Observability Lab

![AWS](https://img.shields.io/badge/AWS-EKS-orange)
![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.35-326CE5)
![OpenTelemetry](https://img.shields.io/badge/OpenTelemetry-Enabled-6D28D9)
![Splunk](https://img.shields.io/badge/Splunk-Observability-65A637)

## Overview

This repository contains the Infrastructure-as-Code (IaC), Kubernetes configuration, and deployment artifacts used to build a repeatable Amazon Elastic Kubernetes Service (EKS) observability lab.

The lab provides a production-inspired environment for learning and experimenting with modern cloud-native observability using:

- Amazon EKS
- Terraform
- OpenTelemetry
- Splunk Observability Cloud
- Splunk Cloud Platform
- Kubernetes-native applications

The infrastructure is designed to be fully reproducible through Terraform, allowing the entire environment to be created, validated, destroyed, and recreated with confidence.

Beyond infrastructure provisioning, this repository serves as a hands-on deployment guide for installing and validating the complete observability stack, from the Kubernetes cluster through telemetry collection and application instrumentation.

---

## Current Implementation

The current implementation provisions the AWS infrastructure, Kubernetes platform, and supporting components required to build a repeatable observability lab.

### AWS Infrastructure

The following AWS resources are provisioned and managed through Terraform:

- Amazon VPC
- Public Subnets across three Availability Zones
- Internet Gateway
- Route Tables and Associations
- IAM Roles and Policies
- Amazon EKS Cluster
- Amazon EKS Managed Node Group

### Amazon EKS Add-ons

The following Kubernetes add-ons are installed automatically during cluster provisioning:

- Amazon VPC CNI
- CoreDNS
- kube-proxy
- Metrics Server
- kube-state-metrics
- EKS Pod Identity Agent
- EKS Node Monitoring Agent

### Observability Components

The following observability components are deployed after the Kubernetes cluster is created:

- Splunk OpenTelemetry Collector
- Splunk Observability Cloud
- Splunk Cloud Platform
- Log Observer Connect

---

## Architecture

### Infrastructure Architecture

```text
AWS (us-east-2)
│
└── Amazon VPC
    ├── Public Subnet (us-east-2a)
    ├── Public Subnet (us-east-2b)
    ├── Public Subnet (us-east-2c)
    ├── Internet Gateway
    └── Amazon EKS
        ├── Managed Control Plane
        ├── Managed Node Group
        └── EKS Add-ons
            ├── Amazon VPC CNI
            ├── CoreDNS
            ├── kube-proxy
            ├── Metrics Server
            ├── kube-state-metrics
            ├── Pod Identity Agent
            └── Node Monitoring Agent
```

### Observability Architecture

```text
                          Applications
                   (Astronomy Shop, AI App,
                      KubeInvaders, etc.)
                               │
                               ▼
                 OpenTelemetry Protocol (OTLP)
                               │
                               ▼
                  Splunk OTel Collector Agent
                     (DaemonSet on every node)
                               │
              ┌────────────────┴─────────────────┐
              ▼                                  ▼
     Splunk Observability Cloud         Splunk Cloud Platform
     • Metrics                          • Container Logs
     • Traces                           • Kubernetes Events
     • Infrastructure                   • Kubernetes Objects
              ▲                                  │
              │                                  ▼
              └──────── Log Observer Connect ────┘

                 Cluster Receiver
                 (Cluster-wide telemetry)
                        │
                        ├── Kubernetes Metrics
                        ├── Kubernetes Metadata
                        ├── Kubernetes Events
                        └── Kubernetes Objects
```

### Repository Structure

```text
.
├── README.md
├── .gitignore
├── terraform/
│   ├── .terraform.lock.hcl
│   ├── providers.tf
│   ├── variables.tf
│   ├── locals.tf
│   ├── vpc.tf
│   ├── iam.tf
│   ├── eks.tf
│   ├── addons.tf
│   ├── nodegroup.tf
│   ├── outputs.tf
│   └── splunk-pod-identity.tf
│
├── observability/
│   └── splunk/
│       ├── values/
│       │   ├── values.yaml.example      # Template used to create the deployment configuration.
│       │   ├── values.yaml              # Template used to create the deployment configuration (not committed).
│       │   └── values-lab.yaml          # Fully documented reference with architecture and design decisions
│       │
│       └── vendor/
│           ├── README.md
│           └── splunk-otel-collector/   # Upstream chart v0.156.0 retained for reference  
│               ├── charts/
│               ├── ci/
│               ├── scripts/
│               ├── templates/
│               ├── .helmignore
│               ├── Chart.lock
│               ├── Chart.yaml
│               ├── OWNERS
│               ├── RELEASE.md
│               ├── values.schema.json
│               └── values.yaml
│
└── applications/
    └── astronomy-shop/
        ├── values/
        │   ├── values.yaml              # Template used to create the deployment configuration.
        │   ├── values-lab.yaml          # Template used to create the deployment configuration with design\override decisions
        │   └── values-reference.yaml    # Upstream chart retained for reference 
        └── CHART-README.md
```

### Repository Layout

| Directory | Purpose |
|----------|---------|
| `terraform/`     | Infrastructure-as-Code for the AWS networking, IAM, EKS cluster, managed node group, and Kubernetes add-ons. |
| `observability/` | Configuration related to the Splunk OpenTelemetry Collector and observability platform. |
| `applications/`  | Kubernetes applications deployed into the lab to demonstrate observability and instrumentation. |

---

## Environment Details

| Component                    | Value |
|------------------------------|-------|
| Cloud Provider               | AWS |
| AWS Region                   | us-east-2 |
| Kubernetes Distribution      | Amazon EKS |
| Kubernetes Version           | 1.35 |
| Worker Node Instance Type    | m6i.xlarge |
| Initial Worker Node Count    | 2 |
| Worker Node Operating System | Amazon Linux 2023 |
| Infrastructure Management    | Terraform |
| Package Manager              | Helm |
| Observability Framework      | OpenTelemetry |
| Collector                    | Splunk OpenTelemetry Collector |
| Metrics & Traces Platform    | Splunk Observability Cloud |
| Logs Platform                | Splunk Cloud Platform |

---

## Prerequisites

Before deploying the lab, ensure the following software and accounts are available.

| Requirement                | Purpose |
|----------------------------|---------|
| AWS Account                | Deploy the Amazon EKS infrastructure. |
| AWS CLI                    | Authenticate and interact with AWS services. |
| Terraform                  | Provision the AWS infrastructure. |
| kubectl                    | Manage Kubernetes resources. |
| Helm                       | Deploy the Splunk OpenTelemetry Collector Helm chart. |
| Git                        | Clone the repository. |
| Splunk Observability Cloud | Receive metrics and traces. |
| Splunk Cloud Platform      | Receive logs, Kubernetes events, and Kubernetes objects. |

### Verify Installed Software

```bash
aws --version
terraform version
kubectl version --client
helm version
git --version
```

### AWS Authentication

Authenticate to AWS before deploying:

```bash
aws configure
```

Verify your AWS credentials are configured.

```bash
aws sts get-caller-identity
```

Before deploying using terraform. Update a few variables (variables.tf file) for your ENV:
aws_region
cluster_name
environment
project_name
owner

---

## Phase 1 - Deploy AWS Infrastructure

Initialize the Terraform working directory.

```bash
terraform init
```

Validate the Terraform configuration.

```bash
terraform validate
```

Review the execution plan.

```bash
terraform plan
```

Deploy the infrastructure.

```bash
terraform apply
```

Verify the EKS cluster was created successfully.

```bash
aws eks list-clusters
```

---

## Phase 2 - Configure Kubernetes Access

After the Amazon EKS cluster has been successfully deployed, configure your local Kubernetes client (`kubectl`) to communicate with the cluster.

### 2.1 Update the Kubernetes Configuration

Configure your local kubeconfig to access the Amazon EKS cluster.

```bash
aws eks update-kubeconfig \
  --region us-east-2 \
  --name ramalo-observability-lab-cluster
```

### 2.2 Verify the Current Context

Confirm that `kubectl` is using the correct Kubernetes context.

```bash
kubectl config current-context
```

### 2.3 Verify Cluster Connectivity

Verify that the Kubernetes API server is reachable.

```bash
kubectl cluster-info
```

### 2.5 Verify the Worker Nodes

Confirm that the managed node group is healthy and all worker nodes are in the `Ready` state.

```bash
kubectl get nodes
```

```bash
kubectl get nodes -o wide
```

### 2.6 Verify the Kubernetes System Pods

Confirm that the core Amazon EKS components are running successfully.

```bash
kubectl get pods -A
```

```bash
kubectl get pods -A -o wide
```

Verify that pods such as the following are in the `Running` state:

- CoreDNS
- kube-proxy
- Amazon VPC CNI
- EKS Pod Identity Agent
- kube-state-metrics
- EKS Node Monitoring Agent

### 2.7 Verify Metrics Server:

```bash
kubectl top nodes
```

### 2.8 Create the Splunk Namespace

Create a dedicated namespace for the Splunk OpenTelemetry Collector.

```bash
kubectl create namespace splunk
```

Verify the namespace was created successfully.

```bash
kubectl get namespaces
```

---

## Phase 3 - Deploy the Splunk OpenTelemetry Collector

This phase deploys the Splunk OpenTelemetry Collector using the official Helm chart. The Collector is responsible for collecting Kubernetes, infrastructure, application, and OpenTelemetry telemetry and exporting it to Splunk Observability Cloud and Splunk Cloud Platform.

### 3.1 Verify the Helm Repository

Confirm that the Splunk Helm repository has been added and update it to retrieve the latest chart metadata.

```bash
helm repo list
```

If the Splunk repository has not been added, run:

```bash
helm repo add splunk-otel-collector-chart https://signalfx.github.io/splunk-otel-collector-chart
```

Update the repository:

```bash
helm repo update
```

### 3.2 Create the Kubernetes Secret

The Splunk OpenTelemetry Collector requires a Kubernetes Secret containing:

- Splunk Observability Cloud ingest token
- Splunk Cloud Platform HEC token

This Secret must be recreated whenever the EKS cluster is rebuilt.

#### Load the Tokens

Load both tokens into temporary shell variables.

```bash
read -s "SPLUNK_O11Y_TOKEN?Paste Splunk Observability Cloud ingest token: "
echo

read -s "SPLUNK_HEC_TOKEN?Paste Splunk Cloud Platform HEC token: "
echo
```

Verify both variables were loaded.

```bash
if [[ -n "$SPLUNK_O11Y_TOKEN" && -n "$SPLUNK_HEC_TOKEN" ]]; then
  echo "Both Splunk tokens are loaded"
else
  echo "One or both Splunk tokens are missing"
fi
```

#### Create or Update the Secret

```bash
kubectl create secret generic splunk-otel-secret \
  --namespace splunk \
  --from-literal=splunk_observability_access_token="$SPLUNK_O11Y_TOKEN" \
  --from-literal=splunk_platform_hec_token="$SPLUNK_HEC_TOKEN" \
  --dry-run=client \
  -o yaml | kubectl apply -f -
```

Verify the Secret was created successfully.

```bash
kubectl get secret -n splunk splunk-otel-secret 
```

Expected output:

```text
NAME                  TYPE     DATA   AGE
splunk-otel-secret    Opaque   2      10s
```

(Optional) Remove the temporary shell variables.

```bash
unset SPLUNK_O11Y_TOKEN
unset SPLUNK_HEC_TOKEN
```

> **Note**
>
> The access tokens are stored in the Kubernetes Secret and are intentionally **not** committed to source control.

### 3.3 Review the Helm Values

The repository includes two Helm values files.

| File | Purpose |
|------|---------|
| `values.yaml.example` | Minimal deployment overrides used during installation. |
| `values-lab.yaml`     | Fully documented reference explaining each configuration decision and architecture. |

Deployments in this guide use:

```text
observability/splunk/values/values.yaml
```

### 3.4 Validate the Helm Chart - Optional - Show me what you would install.

Render the Kubernetes manifests locally before deploying.

```bash
helm template splunk-otel-collector \
  splunk-otel-collector-chart/splunk-otel-collector \
  --namespace splunk \
  --version 0.156.0 \
  -f observability/splunk/values/values.yaml
```

Review the rendered manifests for any configuration issues.

### 3.5 Deploy the Collector

Install the Splunk OpenTelemetry Collector.

```bash
helm install splunk-otel-collector \
  splunk-otel-collector-chart/splunk-otel-collector \
  --namespace splunk \
  --version 0.156.0 \
  -f observability/splunk/values/values.yaml
```

### 3.6 Verify the Helm Release

Confirm that the Helm release was installed successfully.

```bash
helm status splunk-otel-collector -n splunk
```

```bash
helm list -n splunk
```

### 3.7 Verify Service Account

```bash
kubectl get deployment \
  splunk-otel-collector-k8s-cluster-receiver \
  -n splunk \
  -o jsonpath='{.spec.template.spec.serviceAccountName}{"\n"}'
```

Expected output:
splunk-otel-collector

> **Note**
>
> The `splunk-otel-collector` Kubernetes service account is associated with an AWS EKS Pod Identity that is provisioned by Terraform. This allows the Collector to automatically retrieve temporary AWS credentials for Kubernetes resource enrichment without requiring static credentials or IAM Roles for Service Accounts (IRSA).

#### Apply Future Configuration Changes - Optional - Only when you make changes to values.yaml

After changing `values.yaml` on an existing installation, apply the updated configuration:

```bash
helm upgrade splunk-otel-collector \
  splunk-otel-collector-chart/splunk-otel-collector \
  --namespace splunk \
  --version 0.156.0 \
  -f observability/splunk/values/values.yaml
```

---

## Phase 4 - Verify Telemetry

After the Splunk OpenTelemetry Collector has been deployed successfully, verify that telemetry is flowing from the Amazon EKS cluster to Splunk Observability Cloud and Splunk Cloud Platform.

### 4.1 Verify the Collector is Running

Confirm that both Collector components are healthy. List the Collector pod names:

```bash
kubectl get pods -n splunk
```

Also inspect Kubernetes events:

```bash
kubectl describe pod -n splunk <pod-name>
```

### 4.2 Verify the Collector Logs

List the Collector pod names and Check an agent pod:

```bash
kubectl logs -n splunk <agent-pod-name>
```

Check the cluster receiver:

```bash
kubectl logs -n splunk <cluster-receiver-pod-name>
```

Optional: For a pod in `CrashLoopBackOff`, inspect the previous container logs:

```bash
kubectl logs -n splunk <pod-name> --previous
```

### 4.3 Verify Infrastructure Metrics

In Splunk Observability Cloud, verify that:

- Kubernetes cluster appears
- Worker nodes are reporting
- CPU metrics are present
- Memory metrics are present
- Disk metrics are present
- Network metrics are present

### 4.4 Verify Kubernetes Metrics

Open **Kubernetes Navigator** and verify:

- Cluster
- Nodes
- Namespaces
- Pods
- Containers

are being discovered.

### 4.5 Verify Logs

In Splunk Cloud Platform, search the configured index.

Example SPL:

```spl
index=<splunk-index>
```

Verify that:

- Container logs
- Kubernetes events
- Kubernetes objects

are being ingested.

### 4.6 Configure Log Observer Connect

Log Observer Connect correlates infrastructure entities in Splunk Observability Cloud with logs stored in Splunk Cloud Platform.

1. In Splunk Observability Cloud, navigate to **Settings > Log Observer Connect**.
2. Select **Splunk Cloud Platform** as the log source.
3. Configure the connection to your Splunk Cloud Platform deployment.
4. Verify the connection status shows **Connected**.

> **Prerequisite:** Logs must already be ingested into Splunk Cloud Platform.

#### 4.7 Verify Log Observer Connect

From Splunk Observability Cloud:

1. Open **Infrastructure** or **Kubernetes Navigator**.
2. Select a node or pod.
3. Open the **Logs** tab.

Verify that:

- Splunk Cloud Platform opens.
- Related logs for the selected Kubernetes resource are displayed.
- The search is automatically filtered to the selected entity.

### 4.8 Verify Kubernetes Events

Generate a Kubernetes event.

```bash
kubectl rollout restart deployment coredns -n kube-system
```

Verify that the rollout event appears in Splunk Cloud Platform.

### 4.9 Verify End-to-End Telemetry

Confirm that:

- Infrastructure metrics are visible.
- Kubernetes metrics are visible.
- Logs are searchable.
- Kubernetes events are searchable.
- Kubernetes objects are indexed.
- Metrics and logs are correlated through Log Observer Connect.

At this point, the observability platform is fully operational and ready for application deployments.

---

## Phase 5 - Deploy Astronomy Shop App

Add the OpenTelemetry Helm repository.

```bash
helm repo add open-telemetry \
  https://open-telemetry.github.io/opentelemetry-helm-charts
```

Update the local Helm repository cache.

```bash
helm repo update
```

Verify the OpenTelemetry Helm repository is available.

```bash
helm repo list
```

Create the Astronomy Shop namespace.

```bash
kubectl create namespace astronomy-shop
```

Deploy the OpenTelemetry Astronomy Shop application.

```bash
helm install astronomy-shop \
  open-telemetry/opentelemetry-demo \
  --namespace astronomy-shop \
  --version 0.40.10 \
  --values applications/astronomy-shop/values/values.yaml
```

Verify the Helm release was successfully installed.

```bash
helm list -n astronomy-shop
```

Verify all application pods are running.

```bash
kubectl get pods -n astronomy-shop
```

Monitor the pods until they reach the **Running** state.

```bash
kubectl get pods -n astronomy-shop -w
```

Show every Deployment in the `astronomy-shop` namespace.

```bash
kubectl get deployments -n astronomy-shop
```

Show every StatefulSet in the `astronomy-shop` namespace.

```bash
kubectl get statefulsets -n astronomy-shop
```

Show every Service in the `astronomy-shop` namespace.

```bash
kubectl get services -n astronomy-shop
```

Verify the OpenTelemetry Collector Deployment is running.

```bash
kubectl get deployment otel-collector \
  -n astronomy-shop
```

```bash
kubectl describe pod <pod-name> -n astronomy-shop
```

View the most recent OpenTelemetry Collector log messages.

```bash
kubectl logs \
  deployment/otel-collector \
  -n astronomy-shop \
  --tail=100
```

Describe the OpenTelemetry Collector Deployment.

```bash
kubectl describe deployment otel-collector \
  -n astronomy-shop
```

Search the Collector logs for common errors and connection issues. No errors is a good thing.

```bash
kubectl logs \
  deployment/otel-collector \
  -n astronomy-shop \
  --tail=300 \
  | grep -iE 'error|failed|retry|refused|unavailable'
```

Verify the frontend service exists.

```bash
kubectl get service frontend-proxy \
  -n astronomy-shop
```

Create a local connection to the Astronomy Shop frontend via a different terminal.

```bash
kubectl port-forward \
  service/frontend-proxy \
  8080:8080 \
  -n astronomy-shop
```

Open the Astronomy Shop user interfaces.

```text
http://localhost:8080
http://localhost:8080/jaeger/ui/
http://localhost:8080/grafana/
http://localhost:8080/loadgen/
http://localhost:8080/feature/
```

### OpenTelemetry Astronomy Shop Application Architecture
> **Architecture Note**
>
> The OpenTelemetry Astronomy Shop application uses a dedicated OpenTelemetry Collector (`otel-collector`) within the `astronomy-shop` namespace. Application services send their telemetry to this local Collector, which preserves the demo's built-in functionality (such as Jaeger, Grafana, OpenSearch, and span metrics) while forwarding a copy of the telemetry to the central Splunk OpenTelemetry Collector in the `splunk` namespace. The Splunk Collector then processes and exports the telemetry to Splunk Observability Cloud.

> The OpenTelemetry Demo application emits Kubernetes metadata such as k8s.container.name, but it does not include a service.name field in the log events sent to Splunk Cloud Platform. Since the container names match the OpenTelemetry service names (for example, ad, accounting, and frontend), creating a field alias from k8s.container.name to service.name enables Splunk Observability Cloud to correlate logs with APM services without modifying or rebuilding the application images.

>
> ```text
>Astronomy Shop Services
>        │
>        ▼
>Application Logs
>        │
>        ▼
>Astronomy Shop otel-collector
>        │
>        ▼
>Splunk otel-collector-agent
>        │
>        ▼
>Splunk Cloud Platform
>        │
>        │  Field Alias:
>        │  k8s.container.name → service.name
>        ▼
>Splunk Observability Cloud
>        │
>        ▼
>APM ↔ Logs Correlation
> ```

---

## Phase 6 - Destroy the Lab

When you have finished using the lab, destroy all AWS resources to avoid unnecessary charges.

### Destroy the Infrastructure

```bash
terraform destroy
```

After the destroy completes, verify that the Amazon EKS cluster and associated AWS resources have been removed.

> **Note**
>
> Destroying the EKS cluster also removes all Kubernetes resources, including the Splunk OpenTelemetry Collector deployment and Kubernetes Secrets. The next deployment will require recreating the Splunk Kubernetes Secret before installing the Collector.

---

## Phase 7 - AI Application
Deploy AI Application

---

## Phase 8 - Deploy KubeInvaders

### Add a manifest relationship summary

This would be useful near the beginning of Phase 8:

```markdown
### KubeInvaders Manifest Structure

| Manifest | Purpose |
|------------------------------|---|
| `namespace.yaml`             | Creates the namespace where KubeInvaders and Programming Mode Jobs run. |
| `serviceaccount.yaml`        | Creates the restricted identity used by the KubeInvaders pod. |
| `rbac.yaml`                  | Grants Game Mode access to inspect and delete pods only in `astronomy-shop`. |
| `programming-mode-rbac.yaml` | Grants Programming Mode access to create and manage Jobs in `kubeinvaders`. |
| `deployment.yaml`            | Runs KubeInvaders using `kinv-sa` and enables Prometheus metric discovery. |
| `service.yaml`               | Provides stable access to the application and `/metrics` endpoint on port `8080`. |

The manifests work together as follows:

```text
Deployment
    │
    └── uses kinv-sa
            ├── Game Mode RBAC
            │     └── astronomy-shop pod access
            └── Programming Mode RBAC
                  └── KubeInvaders Job access

Service
    │
    └── selects the Deployment pod
            ├── Web interface
            └── /metrics endpoint

KubeInvaders provides a controlled chaos-engineering interface for testing
Kubernetes application resilience.

In this lab:

- KubeInvaders runs in the `kubeinvaders` namespace.
- Game Mode targets pods in the `astronomy-shop` namespace.
- Programming Mode creates temporary Kubernetes Jobs in the
  `kubeinvaders` namespace.
- KubeInvaders metrics are scraped by the Splunk OpenTelemetry Collector
  and sent to Splunk Observability Cloud.

> **Warning**
>
> KubeInvaders can delete pods and create resource-intensive workloads.
> Deploy it only in a lab or other approved non-production environment.

### 8.1 Verify the Kubernetes Context

Before deploying, verify that `kubectl` is connected to the intended EKS
cluster.

```bash
kubectl config current-context
```

Verify cluster connectivity:
```bash
kubectl get nodes
```

Verify that the target application namespace exists:
```bash
kubectl get namespace astronomy-shop
```

### 8.2 Create the Manifest Directory
```bash
mkdir -p applications/kubeinvaders/manifests
```

### 8.3 Create the KubeInvaders Namespace: namespace.yaml
The `namespace.yaml` manifest creates an isolated namespace for the
KubeInvaders application and its Programming Mode Jobs.

Validate the namespace.yaml manifest:
```bash
kubectl apply \
  --dry-run=server \
  -f applications/kubeinvaders/manifests/namespace.yaml
```

Apply namespace.yaml manifest:
```bash
kubectl apply \
  -f applications/kubeinvaders/manifests/namespace.yaml
```

Verify namespace.yaml manifest created:
```bash
kubectl get namespace kubeinvaders
```

### 8.4 Create the KubeInvaders ServiceAccount: serviceaccount.yaml
The `serviceaccount.yaml` manifest creates the restricted Kubernetes identity
used by the KubeInvaders pod.

Validate the serviceaccount.yaml manifest:
```bash
kubectl apply \
  --dry-run=server \
  -f applications/kubeinvaders/manifests/serviceaccount.yaml
```

Apply serviceaccount.yaml manifest:
```bash
kubectl apply \
  -f applications/kubeinvaders/manifests/serviceaccount.yaml
```

Verify serviceaccount.yaml manifest created:
```bash
kubectl get serviceaccount kinv-sa \
  -n kubeinvaders
```

### 8.5 Create the KubeInvaders Game Mode RBAC: rbac.yaml
The `rbac.yaml` manifest grants kinv-sa limited access to the
astronomy-shop namespace.

These permissions allow KubeInvaders to list, inspect, watch, and delete
Astronomy Shop pods during Game Mode. The permissions are scoped only to the
target namespace.

Validate the rbac.yaml manifest:
```bash
kubectl apply \
  --dry-run=server \
  -f applications/kubeinvaders/manifests/rbac.yaml
```

Apply rbac.yaml manifest:
```bash
kubectl apply \
  -f applications/kubeinvaders/manifests/rbac.yaml
```

Verify rbac.yaml manifest created:
```bash
kubectl get role kubeinvaders-target-role \
  -n astronomy-shop
```

```bash
kubectl get rolebinding kubeinvaders-target-binding \
  -n astronomy-shop
```

#### Verify Game Mode Permissions
Verify
Confirm that KubeInvaders can list Astronomy Shop pods:
```bash
kubectl auth can-i list pods \
  --namespace astronomy-shop \
  --as=system:serviceaccount:kubeinvaders:kinv-sa
```
Expected output:
yes

Confirm that KubeInvaders can delete Astronomy Shop pods:
```bash
kubectl auth can-i delete pods \
  --namespace astronomy-shop \
  --as=system:serviceaccount:kubeinvaders:kinv-sa
```
Expected output:
yes

Confirm that the ServiceAccount cannot delete Splunk pods:
```bash
kubectl auth can-i delete pods \
  --namespace splunk \
  --as=system:serviceaccount:kubeinvaders:kinv-sa
```
Expected output:
no

Confirm that the ServiceAccount cannot delete Kubernetes system pods:
```bash
kubectl auth can-i delete pods \
  --namespace kube-system \
  --as=system:serviceaccount:kubeinvaders:kinv-sa
```
Expected output:
no

### 8.6 Create the KubeInvaders Programming Mode RBAC: programming-mode-rbac.yaml
The `programming-mode-rbac.yaml` manifest grants kinv-sa permission to
create and manage Kubernetes Jobs and their pods in the KubeInvaders
namespace.

Programming Mode creates its chaos Jobs in the KubeInvaders namespace rather
than in the selected application namespace.

Validate the programming-mode-rbac.yaml manifest:
```bash
kubectl apply \
  --dry-run=server \
  -f applications/kubeinvaders/manifests/programming-mode-rbac.yaml
```

Apply programming-mode-rbac.yaml manifest:
```bash
kubectl apply \
  -f applications/kubeinvaders/manifests/programming-mode-rbac.yaml
```

Verify programming-mode-rbac.yaml manifest created:
```bash
kubectl get role kubeinvaders-programming-mode \
  -n kubeinvaders
```

```bash
kubectl get rolebinding kubeinvaders-programming-mode \
  -n kubeinvaders
```

#### Verify Programming Mode Permissions
Confirm that KubeInvaders can create Kubernetes Jobs in the
`kubeinvaders` namespace:
```bash
kubectl auth can-i create jobs.batch \
  --as=system:serviceaccount:kubeinvaders:kinv-sa \
  -n kubeinvaders
```
Expected output:
yes

### 8.7 Create the KubeInvaders Deployment: deployment.yaml
The `deployment.yaml` manifest runs the KubeInvaders application.

The Deployment:
- Uses the `kinv-sa` ServiceAccount.
- Runs in the `kubeinvaders` namespace.
- Exposes the application on container port `8080`.
- Includes Prometheus annotations so the Splunk OpenTelemetry Collector can
  discover and scrape the `/metrics` endpoint.

Validate the deployment.yaml manifest:
```bash
kubectl apply \
  --dry-run=server \
  -f applications/kubeinvaders/manifests/deployment.yaml
```

Apply deployment.yaml manifest:
```bash
kubectl apply \
  -f applications/kubeinvaders/manifests/deployment.yaml
```

Verify deployment.yaml manifest:
```bash
kubectl get deployment kubeinvaders \
  -n kubeinvaders
```

Wait for the Deployment to become available:

```bash
kubectl rollout status deployment/kubeinvaders \
  -n kubeinvaders
```

```bash
  kubectl logs \
  -n kubeinvaders \
  deployment/kubeinvaders
```

Follow the logs during testing:
```bash
kubectl logs \
  -n kubeinvaders \
  deployment/kubeinvaders \
  --follow \
  --timestamps
```
These logs were essential when we diagnosed the Programming Mode `403 Forbidden` error.

Verify the Kubeinvaders Pods:
```bash
kubectl get pods \
  -n kubeinvaders \
  -l app.kubernetes.io/name=kubeinvaders \
  -o wide
```

Confirm that the pod uses kinv-sa:
```bash
kubectl get pods \
  -n kubeinvaders \
  -l app.kubernetes.io/name=kubeinvaders \
  -o jsonpath='{.items[0].spec.serviceAccountName}{"\n"}'
```
Expected output:
kinv-sa

Verify the Prometheus annotations:
```bash
kubectl get pods \
  -n kubeinvaders \
  -l app.kubernetes.io/name=kubeinvaders \
  -o jsonpath='{.items[0].metadata.annotations}{"\n"}'
```
The output should contain:
prometheus.io/scrape:true
prometheus.io/path:/metrics
prometheus.io/port:8080

### 8.8 Create the KubeInvaders Service: service.yaml
The service.yaml manifest provides a stable ClusterIP endpoint for the
KubeInvaders application.

The Service listens on port 8080 and forwards traffic to port 8080 on the
KubeInvaders pod.

Validate the service.yaml manifest:
```bash
kubectl apply \
  --dry-run=server \
  -f applications/kubeinvaders/manifests/service.yaml
```

Apply service.yaml manifest:
```bash
kubectl apply \
  -f applications/kubeinvaders/manifests/service.yaml
```

Verify service.yaml manifest:
```bash
kubectl get service kubeinvaders \
  -n kubeinvaders
```

### 8.9 Access KubeInvaders

Port-forward local port 8081 to the KubeInvaders Service port 8080.

Port 8081 is used locally because port 8080 is already used by the
Astronomy Shop application.

```bash
kubectl port-forward \
  service/kubeinvaders \
  8081:8080 \
  -n kubeinvaders
```

Traffic Path:
Laptop port 8081
        ↓
KubeInvaders Service port 8080
        ↓
KubeInvaders pod port 8080

Open the following URL:
```test
http://localhost:8081
```
Verify the Prometheus metrics endpoint:
```test
http://localhost:8081/metrics
```

### 8.10 Configure the Kubernetes Connection

In the KubeInvaders interface, configure the Kubernetes connection using the
following values.

Kubernetes API endpoint:
https://kubernetes.default.svc

Target namespace:
astronomy-shop

Create a temporary ServiceAccount token:
```bash
kubectl create token kinv-sa \
  -n kubeinvaders \
  --duration=8h
```
Copy the token into the KubeInvaders Kubernetes connection configuration.

> **Security**
>
> The token is temporary. Never save it in Git, commit it to the repository,
> or include its value in screenshots or documentation.

Retrieve the Kubernetes cluster CA certificate:
```bash
kubectl exec \
  -n kubeinvaders \
  deployment/kubeinvaders \
  -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```
Copy the complete certificate, including:

-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----

### 8.11 Verify Game Mode

Watch the Astronomy Shop pods:

```bash
kubectl get pods \
  -n astronomy-shop \
  --watch
```

Use Game Mode to delete a pod.

Verify that:
KubeInvaders deletes the selected pod.
The Deployment creates a replacement pod.
The replacement pod reaches Running.
The KubeInvaders deletion and recovery metrics update.

### 8.12 Verify Programming Mode

Watch Programming Mode Jobs:

```bash
kubectl get jobs \
  -n kubeinvaders \
  --watch
```

In another terminal, watch the chaos pods:

```bash
kubectl get pods \
  -n kubeinvaders \
  -l chaos-controller=kubeinvaders \
  --watch
```

Run a Programming Mode experiment.

Verify that the Jobs complete successfully:

```bash
kubectl get jobs \
  -n kubeinvaders
```

Verify the KubeInvaders metrics:

```bash
curl http://localhost:8081/metrics
```

### 8.13 Repeat the Deployment

Once all six manifests exist, apply them in dependency order:

```bash
kubectl apply \
  -f applications/kubeinvaders/manifests/namespace.yaml
```

```bash
kubectl apply \
  -f applications/kubeinvaders/manifests/serviceaccount.yaml
```

```bash
kubectl apply \
  -f applications/kubeinvaders/manifests/rbac.yaml
```

```bash
kubectl apply \
  -f applications/kubeinvaders/manifests/programming-mode-rbac.yaml
```

```bash
kubectl apply \
  -f applications/kubeinvaders/manifests/deployment.yaml
```

```bash
kubectl apply \
  -f applications/kubeinvaders/manifests/service.yaml
```

---

## Phase 9
Dashboards

---

## Phase 10
Detectors

---

## Future Enhancements

The following capabilities are planned for future phases of this lab:

- Deploy the AI application with OpenTelemetry instrumentation.
- Build custom dashboards in Splunk Observability Cloud.
- Create detectors and alerts for infrastructure and application health.

---

---

## Author

**Ramalo Singh**

Technical Leader specializing in Cloud Observability, OpenTelemetry, Kubernetes, Terraform, and Splunk Observability solutions.

---