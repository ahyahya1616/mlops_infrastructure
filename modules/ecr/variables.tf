variable "repository_name" {
  description = "Name of the Amazon ECR private repository"
  type        = string
  default     = "financial-data-agent"
}

variable "environment" {
  description = "Environment identifier"
  type        = string
  default     = "lab"
}

