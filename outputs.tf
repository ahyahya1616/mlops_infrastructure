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
