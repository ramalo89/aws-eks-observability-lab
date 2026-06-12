resource "aws_iam_role" "eks_cluster" {
  name        = "AmazonEKSClusterRole"
  description = "IAM role assumed by the EKS control plane for the ramalo-observability-lab-cluster."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.eks_cluster_role_tags
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "vpc_cni_pod_identity" {
  name        = "AmazonEKSPodIdentityAmazonVPCCNIRole"
  description = "Provides Amazon VPC CNI permissions to manage ENIs and pod IP address allocation for the ramalo-observability-lab EKS cluster."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = local.vpc_cni_role_tags
}

resource "aws_iam_role_policy_attachment" "vpc_cni_policy" {
  role       = aws_iam_role.vpc_cni_pod_identity.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}