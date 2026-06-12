resource "aws_iam_role" "nodegroup" {
  name        = "AmazonEKSAutoNodeRole"
  description = "Used by EC2 worker nodes to join the cluster and pull images"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.nodegroup_role_tags
}

resource "aws_iam_role_policy_attachment" "nodegroup_worker_policy" {
  role       = aws_iam_role.nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "nodegroup_cni_policy" {
  role       = aws_iam_role.nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "nodegroup_ecr_readonly" {
  role       = aws_iam_role.nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "nodegroup_ecr_public_readonly" {
  role       = aws_iam_role.nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly"
}

resource "aws_eks_node_group" "lab" {
  cluster_name    = aws_eks_cluster.lab.name
  node_group_name = "ramalo-observability-lab-nodegroup"
  node_role_arn   = aws_iam_role.nodegroup.arn

  lifecycle {
    ignore_changes = [
      update_config[0].update_strategy
    ]
  }

  subnet_ids = [
    aws_subnet.public["public1"].id,
    aws_subnet.public["public2"].id,
    aws_subnet.public["public3"].id
  ]

  ami_type       = "AL2023_x86_64_STANDARD"
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.large"]
  disk_size      = 40

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  node_repair_config {
    enabled = false
  }

  labels = {}

  tags = local.nodegroup_tags

  depends_on = [
    aws_iam_role_policy_attachment.nodegroup_worker_policy,
    aws_iam_role_policy_attachment.nodegroup_cni_policy,
    aws_iam_role_policy_attachment.nodegroup_ecr_readonly,
    aws_iam_role_policy_attachment.nodegroup_ecr_public_readonly
  ]
}