output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.lab.name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint."
  value       = aws_eks_cluster.lab.endpoint
}

output "cluster_version" {
  description = "EKS Kubernetes version."
  value       = aws_eks_cluster.lab.version
}

output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.lab.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "eks_cluster_role_arn" {
  description = "EKS cluster IAM role ARN."
  value       = aws_iam_role.eks_cluster.arn
}

output "vpc_cni_role_arn" {
  description = "VPC CNI Pod Identity IAM role ARN."
  value       = aws_iam_role.vpc_cni_pod_identity.arn
}