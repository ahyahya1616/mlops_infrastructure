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

# 3. ECR Module: Private Container Registry with scan-on-push & lifecycle rules
module "ecr" {
  source = "./modules/ecr"

  repository_name = var.ecr_repository_name
  environment     = var.environment
}

# 4. S3 Module: Encrypted Financial Data Lake with strict Public Access Block
module "s3" {
  source = "./modules/s3"

  bucket_name = var.s3_bucket_name
  environment = var.environment
}

# 5. IRSA Module: OIDC IAM Role + Scoped S3 Policy + Kubernetes ServiceAccount
module "irsa" {
  source = "./modules/irsa"

  cluster_name         = module.eks.cluster_name
  oidc_provider_arn    = module.eks.oidc_provider_arn
  oidc_provider_url    = module.eks.oidc_provider_url
  s3_bucket_arn        = module.s3.bucket_arn
  k8s_namespace        = var.k8s_namespace
  service_account_name = var.service_account_name
  environment          = var.environment
}


