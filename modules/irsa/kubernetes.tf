# ==============================================================================
# Kubernetes Workload Namespace & Annotated ServiceAccount
# ==============================================================================

# Target namespace where Kubeflow / Financial Agent pipelines will run
resource "kubernetes_namespace" "this" {
  metadata {
    name = var.k8s_namespace

    labels = {
      name        = var.k8s_namespace
      environment = var.environment
    }
  }
}

# The ServiceAccount that pods bind to for IRSA token injection
resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.service_account_name
    namespace = kubernetes_namespace.this.metadata[0].name

    annotations = {
      # This annotation tells EKS Pod Identity Webhook to inject the OIDC JWT token
      "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
    }
  }
}
