# ==============================================================================
# Root Infrastructure Orchestrator: Zero-Trust MLOps Platform
# ==============================================================================

# 1. VPC Module: Dual-AZ, 1 NAT Gateway, Kubernetes Subnet Tags
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  cluster_name         = var.cluster_name
  environment          = var.environment
}

# 2. EKS Module: Control Plane, Private Managed Node Group, OIDC & eBPF CNI
module "eks" {
  source = "./modules/eks"

  cluster_name        = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  environment         = var.environment
}

