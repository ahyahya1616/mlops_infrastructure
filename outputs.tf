# ==============================================================================
# Outputs: Zero-Trust MLOps Infrastructure
# ==============================================================================

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS Kubernetes API Server URL"
  value       = module.eks.cluster_endpoint
}

output "vpc_id" {
  description = "ID of the provisioned VPC"
  value       = module.vpc.vpc_id
}

output "nat_public_ip" {
  description = "Public IP of the Single NAT Gateway (Whitelisted for egress)"
  value       = module.vpc.nat_public_ip
}

output "oidc_provider_arn" {
  description = "IAM OIDC Provider ARN (Prerequisite for IRSA in Phase 3)"
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "OIDC Issuer URL"
  value       = module.eks.oidc_provider_url
}

output "configure_kubectl_command" {
  description = "Command to configure local kubectl credentials for this cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

# ==============================================================================
# Phase 3 Outputs: ECR, S3 & IRSA
# ==============================================================================

output "ecr_repository_url" {
  description = "URL of the Amazon ECR private repository"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the Amazon ECR private repository"
  value       = module.ecr.repository_arn
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for financial datasets"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for financial datasets"
  value       = module.s3.bucket_arn
}

output "irsa_iam_role_arn" {
  description = "IAM Role ARN assumed by the financial agent via IRSA"
  value       = module.irsa.role_arn
}

output "irsa_service_account_name" {
  description = "Kubernetes ServiceAccount bound to the IRSA role"
  value       = module.irsa.service_account_name
}

output "irsa_namespace" {
  description = "Kubernetes namespace where the IRSA ServiceAccount is deployed"
  value       = module.irsa.namespace
}

