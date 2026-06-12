# AWS EKS Observability Lab

## Overview

This repository contains the Infrastructure-as-Code (IaC) used to build a repeatable Amazon Elastic Kubernetes Service (EKS) environment using Terraform.

The goal of this project is to establish a reusable Kubernetes foundation that can be used for learning, experimentation, observability, and cloud-native application deployments.

The environment has been validated through multiple Terraform deployment and destruction cycles to ensure the infrastructure can be recreated consistently.

---

## Current Scope

The current implementation focuses on provisioning and managing the AWS infrastructure required for a Kubernetes platform.

### AWS Resources

* Amazon VPC
* Public Subnets across three Availability Zones
* Internet Gateway
* Route Tables and Associations
* IAM Roles and Policies
* Amazon EKS Cluster
* Amazon EKS Managed Node Group

### EKS Add-ons

* VPC CNI
* CoreDNS
* Kube Proxy
* Metrics Server
* Kube State Metrics
* EKS Pod Identity Agent
* EKS Node Monitoring Agent

---

## Architecture

```text
AWS
└── VPC
    ├── Public Subnet (us-east-2a)
    ├── Public Subnet (us-east-2b)
    ├── Public Subnet (us-east-2c)
    ├── Internet Gateway
    └── Amazon EKS
        ├── Control Plane
        ├── Managed Node Group
        └── EKS Add-ons
```

---

## Environment Details

| Component                 | Value             |
| ------------------------- | ----------------- |
| Cloud Provider            | AWS               |
| Region                    | us-east-2         |
| Kubernetes Version        | 1.35              |
| Node Type                 | t3.large          |
| Node Count                | 2                 |
| Operating System          | Amazon Linux 2023 |
| Infrastructure Management | Terraform         |

---

## Repository Structure

```text
.
├── README.md
├── .gitignore
└── terraform/
    ├── providers.tf
    ├── variables.tf
    ├── locals.tf
    ├── vpc.tf
    ├── iam.tf
    ├── eks.tf
    ├── addons.tf
    ├── nodegroup.tf
    └── outputs.tf
```

---

## Deployment

Initialize Terraform:

```bash
terraform init
```

Validate Configuration:

```bash
terraform validate
```

Review Planned Changes:

```bash
terraform plan
```

Deploy Infrastructure:

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

## Verification

Verify worker nodes:

```bash
kubectl get nodes -o wide
```

Verify cluster add-ons:

```bash
kubectl get pods -A
```

Verify Metrics Server:

```bash
kubectl top nodes
```

Verify Terraform state:

```bash
terraform plan
```

Expected result:

```text
No changes. Your infrastructure matches the configuration.
```

---

## Destroy Environment

```bash
terraform destroy
```

---

## Future Enhancements

Planned future phases include:

* KubeInvaders deployment
* Splunk OpenTelemetry Collector
* Splunk Observability Cloud integration
* Application instrumentation
* Kubernetes observability dashboards
* CI/CD automation

---

## Author

Ramalo Singh

AWS | Kubernetes | Terraform | Observability