resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.lab.name
  addon_name    = "vpc-cni"
  addon_version = "v1.21.1-eksbuild.1"

  pod_identity_association {
    role_arn        = aws_iam_role.vpc_cni_pod_identity.arn
    service_account = "aws-node"
  }

  depends_on = [
    aws_eks_cluster.lab,
    aws_iam_role_policy_attachment.vpc_cni_policy
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.lab.name
  addon_name    = "coredns"
  addon_version = "v1.13.2-eksbuild.4"

  depends_on = [
    aws_eks_cluster.lab
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.lab.name
  addon_name    = "kube-proxy"
  addon_version = "v1.35.3-eksbuild.2"

  depends_on = [
    aws_eks_cluster.lab
  ]
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name  = aws_eks_cluster.lab.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.10-eksbuild.3"

  depends_on = [
    aws_eks_cluster.lab
  ]
}

resource "aws_eks_addon" "node_monitoring_agent" {
  cluster_name  = aws_eks_cluster.lab.name
  addon_name    = "eks-node-monitoring-agent"
  addon_version = "v1.6.5-eksbuild.1"

  depends_on = [
    aws_eks_cluster.lab
  ]
}

resource "aws_eks_addon" "metrics_server" {
  cluster_name  = aws_eks_cluster.lab.name
  addon_name    = "metrics-server"
  addon_version = "v0.8.1-eksbuild.6"

  depends_on = [
    aws_eks_cluster.lab
  ]
}

resource "aws_eks_addon" "kube_state_metrics" {
  cluster_name  = aws_eks_cluster.lab.name
  addon_name    = "kube-state-metrics"
  addon_version = "v2.18.0-eksbuild.10"

  depends_on = [
    aws_eks_cluster.lab
  ]
}