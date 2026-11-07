# ==============================================================================
# IAM OpenID Connect (OIDC) Provider for Zero-Trust IRSA
# Allows Kubernetes ServiceAccounts to assume AWS IAM Roles via short-lived JWTs
# ==============================================================================

data "tls_certificate" "eks" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer

  tags = {
    Name = "${var.cluster_name}-irsa-oidc"
  }
}

