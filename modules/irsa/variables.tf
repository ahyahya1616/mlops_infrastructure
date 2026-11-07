variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the IAM OIDC provider for the EKS cluster"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the IAM OIDC issuer"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket to authorize access to"
  type        = string
}

variable "k8s_namespace" {
  description = "Kubernetes namespace for the ServiceAccount"
  type        = string
  default     = "kubeflow"
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount name"
  type        = string
  default     = "financial-data-sa"
}

variable "environment" {
  description = "Environment identifier"
  type        = string
  default     = "lab"
}
