output "aws_region" {
  description = "AWS region containing the EKS cluster."
  value       = var.aws_region
}

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

output "node_group_name" {
  description = "EKS managed node group name."
  value       = aws_eks_node_group.lab.node_group_name
}

output "eks_cluster_role_arn" {
  description = "EKS cluster IAM role ARN."
  value       = aws_iam_role.eks_cluster.arn
}

output "vpc_cni_role_arn" {
  description = "VPC CNI Pod Identity IAM role ARN."
  value       = aws_iam_role.vpc_cni_pod_identity.arn
}

output "splunk_otel_collector_role_arn" {
  description = "Splunk OpenTelemetry Collector Pod Identity IAM role ARN."
  value       = aws_iam_role.splunk_otel_collector.arn
}

output "splunk_otel_collector_pod_identity_association_id" {
  description = "Splunk OpenTelemetry Collector EKS Pod Identity association ID."
  value       = aws_eks_pod_identity_association.splunk_otel_collector.association_id
}