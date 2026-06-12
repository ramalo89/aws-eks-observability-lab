# KubeInvaders on Amazon EKS - Observability Lab

## Overview

This repository contains the Infrastructure-as-Code (IaC) and supporting documentation used to build a cloud-native Kubernetes environment on Amazon EKS.

The purpose of this lab is to:

* Learn and document Amazon EKS fundamentals
* Build a repeatable Kubernetes platform using Terraform
* Deploy and operate KubeInvaders
* Implement OpenTelemetry-based observability
* Integrate telemetry with Splunk Observability Cloud
* Demonstrate platform engineering and cloud-native architecture practices

---

## Architecture

### AWS Components

* Amazon EKS Control Plane
* Amazon EKS Managed Node Group
* Amazon VPC
* Public Subnets across 3 Availability Zones
* Internet Gateway
* Route Tables
* IAM Roles and Policies
* EKS Add-ons

### Kubernetes Components

* CoreDNS
* Kube Proxy
* VPC CNI
* Metrics Server
* Kube State Metrics
* EKS Pod Identity Agent
* EKS Node Monitoring Agent

### Planned Components

* KubeInvaders
* OpenTelemetry Collector
* Splunk Observability Cloud
* Splunk Infrastructure Monitoring
* Splunk APM
* Splunk Log Observer
* Splunk Kubernetes Navigator

---

## Repository Structure

```text
.
├── docs/
│   ├── diagrams/
│   └── screenshots/
│
├── terraform/
│   ├── addons.tf
│   ├── eks.tf
│   ├── iam.tf
│   ├── locals.tf
│   ├── nodegroup.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   └── vpc.tf
│
└── README.md
```

---

## Environment

| Item               | Value                            |
| ------------------ | -------------------------------- |
| Cloud Provider     | AWS                              |
| Region             | us-east-2                        |
| Cluster Name       | ramalo-observability-lab-cluster |
| Kubernetes Version | 1.35                             |
| Node Type          | t3.large                         |
| Node Count         | 2                                |
| OS                 | Amazon Linux 2023                |
| Terraform          | Managed Infrastructure           |

---

## Deployment

### Initialize Terraform

```bash
terraform init
```

### Validate Configuration

```bash
terraform validate
```

### Review Planned Changes

```bash
terraform plan
```

### Deploy Environment

```bash
terraform apply
```

---

## Configure kubectl

```bash
aws eks update-kubeconfig \
  --region us-east-2 \
  --name ramalo-observability-lab-cluster
```

---

## Verification Commands

### Verify Nodes

```bash
kubectl get nodes -o wide
```

### Verify System Pods

```bash
kubectl get pods -A
```

### Verify Metrics Server

```bash
kubectl top nodes
```

### Verify EKS Add-ons

```bash
aws eks list-addons \
  --cluster-name ramalo-observability-lab-cluster
```

---

## Terraform State Verification

### List Managed Resources

```bash
terraform state list
```

### Verify No Drift

```bash
terraform plan
```

Expected Result:

```text
No changes. Your infrastructure matches the configuration.
```

---

## Destroy Environment

```bash
terraform destroy
```

---

## Tagging Strategy

All resources use a standardized tagging model:

| Tag          | Purpose                 |
| ------------ | ----------------------- |
| Name         | Resource Name           |
| Cluster      | Cluster Identifier      |
| Owner        | Resource Owner          |
| Environment  | Environment             |
| Project      | Project Name            |
| CostCenter   | Cost Tracking           |
| ManagedBy    | Terraform               |
| Platform     | AWS / EKS               |
| ResourceType | Resource Classification |

---

## Learning Objectives

* Terraform Fundamentals
* Infrastructure as Code
* Amazon EKS
* Kubernetes Administration
* IAM Design
* VPC Networking
* Managed Node Groups
* EKS Add-ons
* OpenTelemetry
* Splunk Observability Cloud
* Platform Engineering
* Cloud Native Architecture

---

## Author

Ramalo Singh

Observability | Platform Engineering | Kubernetes | OpenTelemetry | AWS
