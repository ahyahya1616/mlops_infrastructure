# ==============================================================================
# IAM Role for Service Accounts (IRSA): Zero-Trust Identity Federation
# ==============================================================================

locals {
  # Strip https:// protocol from issuer URL for IAM condition evaluation
  oidc_issuer_clean = replace(var.oidc_provider_url, "https://", "")
}

# 1. IAM Role with OIDC Trust Condition
resource "aws_iam_role" "this" {
  name = "${var.cluster_name}-financial-agent-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_issuer_clean}:sub" = "system:serviceaccount:${var.k8s_namespace}:${var.service_account_name}"
            "${local.oidc_issuer_clean}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Name = "${var.cluster_name}-financial-agent-s3-role"
  }
}

# 2. Least-Privilege S3 Storage Policy
resource "aws_iam_policy" "this" {
  name        = "${var.cluster_name}-financial-agent-s3-policy"
  description = "Scoped read/write access to financial datasets in S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })

  tags = {
    Name = "${var.cluster_name}-financial-agent-s3-policy"
  }
}

# 3. Policy Attachment
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

