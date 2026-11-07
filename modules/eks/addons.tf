# ==============================================================================
# Amazon EKS Addons
# ==============================================================================

# 1. AWS VPC CNI with native eBPF NetworkPolicy enabled
# Enforces standard Kubernetes NetworkPolicy directly at Linux kernel veth level
resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "vpc-cni"
  resolve_conflicts_on_update = "OVERWRITE"

  configuration_values = jsonencode({
    enableNetworkPolicy = "true"
  })
}

# 2. CoreDNS (Cluster Internal DNS)
# Must wait for worker nodes to be ready so pods can schedule
resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "coredns"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.default
  ]
}

# 3. Kube-Proxy (IPVS / IPTables service routing)
resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "kube-proxy"
  resolve_conflicts_on_update = "OVERWRITE"
}

