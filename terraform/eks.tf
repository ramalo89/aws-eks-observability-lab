resource "aws_eks_cluster" "lab" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  version = var.kubernetes_version

  kubernetes_network_config {
    ip_family         = var.ip_family
    service_ipv4_cidr = var.service_ipv4_cidr
  }

  vpc_config {
    subnet_ids = [
      aws_subnet.public["public1"].id,
      aws_subnet.public["public2"].id,
      aws_subnet.public["public3"].id
    ]

    endpoint_private_access = true
    endpoint_public_access  = true

    public_access_cidrs = [
      var.home_ip_cidr
    ]
  }

  enabled_cluster_log_types = []

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = local.eks_cluster_tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}