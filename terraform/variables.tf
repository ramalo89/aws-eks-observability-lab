variable "aws_region" {
  description = "AWS region where the observability lab is deployed."
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Logical project name used for shared naming and tagging."
  type        = string
  default     = "ramalo-observability-lab"
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
  default     = "ramalo-observability-lab-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.35"
}

variable "cluster_log_types" {
  description = "EKS control-plane log types sent to CloudWatch Logs."
  type        = list(string)

  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  validation {
    condition = alltrue([
      for log_type in var.cluster_log_types :
      contains(
        [
          "api",
          "audit",
          "authenticator",
          "controllerManager",
          "scheduler"
        ],
        log_type
      )
    ])

    error_message = "Valid EKS log types are api, audit, authenticator, controllerManager, and scheduler."
  }
}

variable "service_ipv4_cidr" {
  description = "Kubernetes service IPv4 CIDR block."
  type        = string
  default     = "172.20.0.0/16"
}

variable "ip_family" {
  description = "Kubernetes IP family."
  type        = string
  default     = "ipv4"
}

variable "vpc_name" {
  description = "VPC name matching the manual VPC."
  type        = string
  default     = "ramalo-observability-lab-vpc-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the lab VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet configuration matching the manual VPC."
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))

  default = {
    public1 = {
      cidr_block        = "10.0.0.0/20"
      availability_zone = "us-east-2a"
      name              = "ramalo-observability-lab-vpc-subnet-public1-us-east-2a"
    }

    public2 = {
      cidr_block        = "10.0.16.0/20"
      availability_zone = "us-east-2b"
      name              = "ramalo-observability-lab-vpc-subnet-public2-us-east-2b"
    }

    public3 = {
      cidr_block        = "10.0.32.0/20"
      availability_zone = "us-east-2c"
      name              = "ramalo-observability-lab-vpc-subnet-public3-us-east-2c"
    }
  }
}

variable "environment" {
  description = "Environment tag value."
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner tag value."
  type        = string
  default     = "ramalo"
}

variable "project_tag" {
  description = "Project tag value."
  type        = string
  default     = "observability"
}

variable "cost_center" {
  description = "CostCenter tag value."
  type        = string
  default     = "personal-lab"
}

variable "managed_by" {
  description = "Indicates how the resource is managed."
  type        = string
  default     = "terraform"
}

variable "allowed_api_cidrs" {
  description = "CIDR blocks allowed to access the EKS API endpoint"
  type        = list(string)

  validation {
    condition = alltrue([
      for cidr in var.allowed_api_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "Each value in allowed_api_cidrs must be a valid CIDR block."
  }
}

variable "cluster_role_name" {
  description = "EKS Cluster IAM role name."
  type        = string
  default     = "AmazonEKSClusterRole"
}