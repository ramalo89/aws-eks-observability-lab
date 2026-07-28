resource "aws_iam_role" "splunk_otel_collector" {
  name        = "ramalo-observability-lab-splunk-otel-collector-role"
  description = "Provides the Splunk OpenTelemetry Collector with permissions to discover AWS resources for the ramalo-observability-lab EKS cluster."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEksPodIdentity"
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Condition = {
          StringEquals = {
            "aws:RequestTag/kubernetes-namespace"       = "splunk"
            "aws:RequestTag/kubernetes-service-account" = "splunk-otel-collector"
          }
        }
      }
    ]
  })

  tags = local.splunk_otel_collector_role_tags
}

resource "aws_iam_role_policy" "splunk_otel_collector" {
  name = "ramalo-observability-lab-splunk-otel-collector-policy"
  role = aws_iam_role.splunk_otel_collector.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEc2InstanceDiscovery"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_eks_pod_identity_association" "splunk_otel_collector" {
  cluster_name    = aws_eks_cluster.lab.name
  namespace       = "splunk"
  service_account = "splunk-otel-collector"
  role_arn        = aws_iam_role.splunk_otel_collector.arn

  tags = local.splunk_otel_collector_pod_identity_tags

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy.splunk_otel_collector
  ]
}