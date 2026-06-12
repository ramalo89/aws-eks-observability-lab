locals {
  common_tags = {
    Cluster     = var.project_name
    Owner       = var.owner
    Environment = var.environment
    Project     = var.project_tag
    CostCenter  = var.cost_center
    ManagedBy   = var.managed_by
  }

  eks_cluster_tags = merge(local.common_tags, {
    Name         = var.cluster_name
    Platform     = "eks"
    ResourceType = "eks-cluster"
  })

  vpc_tags = merge(local.common_tags, {
    Name         = var.vpc_name
    Platform     = "aws"
    ResourceType = "vpc"
  })

  public_subnet_tags = {
    for subnet_key, subnet in var.public_subnets :
    subnet_key => merge(local.common_tags, {
      Name         = subnet.name
      Platform     = "aws"
      ResourceType = "vpc"
    })
  }

  internet_gateway_tags = merge(local.common_tags, {
    Name         = "${var.project_name}-vpc-igw"
    Platform     = "aws"
    ResourceType = "vpc"
  })

  public_route_table_tags = merge(local.common_tags, {
    Name         = "${var.project_name}-vpc-rtb-public"
    Platform     = "aws"
    ResourceType = "vpc"
  })

  nodegroup_role_tags = merge(local.common_tags, {
    Name         = "ramalo-observability-lab-nodegroup-role"
    Platform     = "iam"
    ResourceType = "iam-role"
    RoleType     = "eks-nodegroup"
  })

  nodegroup_tags = merge(local.common_tags, {
    Name         = "ramalo-observability-lab-nodegroup"
    Platform     = "eks"
    ResourceType = "eks-nodegroup"
  })

  eks_cluster_role_tags = merge(local.common_tags, {
    Name         = "AmazonEKSClusterRole"
    Platform     = "iam"
    ResourceType = "iam-role"
    RoleType     = "eks-cluster-role"
  })

  vpc_cni_role_tags = merge(local.common_tags, {
    Name         = "AmazonEKSPodIdentityAmazonVPCCNIRole"
    Platform     = "iam"
    ResourceType = "iam-role"
    RoleType     = "vpc-cni"
  })
}