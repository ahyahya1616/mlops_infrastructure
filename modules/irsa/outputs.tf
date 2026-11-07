output "role_arn" {
  description = "ARN of the IAM role assumed by the Kubernetes ServiceAccount"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the IAM role assumed by the Kubernetes ServiceAccount"
  value       = aws_iam_role.this.name
}

output "policy_arn" {
  description = "ARN of the S3 least-privilege policy"
  value       = aws_iam_policy.this.arn
}

output "service_account_name" {
  description = "Name of the Kubernetes ServiceAccount"
  value       = kubernetes_service_account.this.metadata[0].name
}

output "namespace" {
  description = "Namespace where the ServiceAccount resides"
  value       = kubernetes_namespace.this.metadata[0].name
}
