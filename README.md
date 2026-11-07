# Zero-Trust MLOps Infrastructure (AWS EKS & Terraform)

Production-grade, enterprise-hardened Terraform Infrastructure as Code (IaC) for hosting a Zero-Trust MLOps pipeline on Amazon EKS.

---

## Architecture Highlights

* **Network Micro-Segmentation:** Dual-AZ VPC with public and private subnets.
* **Cost-Optimized Egress:** Single NAT Gateway for outbound egress to external APIs (Yahoo Finance, S3) saving ~50% in networking fees.
* **Kubernetes Auto-Discovery:** Explicit `kubernetes.io/role/elb` and `kubernetes.io/role/internal-elb` tags.
* **EKS 1.37 Control Plane:** Managed Kubernetes control plane with private node communication.
* **Private Worker Nodes:** 2x `t3.large` instances residing exclusively in private subnets with zero direct inbound routes from the internet.
* **Native eBPF Network Policies:** AWS VPC CNI configured with `enableNetworkPolicy = "true"` for kernel-level traffic filtering without Calico.
* **Zero-Trust IRSA Engine:** IAM OIDC Identity Provider configured for short-lived token federation.

---

## Directory Structure

```
mlops_infrastructure/
├── versions.tf                 # Provider constraints (AWS ~> 5.0, TLS ~> 4.0)
├── variables.tf                # Input variable definitions
├── terraform.tfvars.example    # Configuration template
├── terraform.tfvars            # Active environment parameters (gitignored)
├── main.tf                     # Root orchestrator
├── outputs.tf                  # Cluster endpoints, OIDC ARN & kubectl helper
│
└── modules/
    ├── vpc/                    # VPC, Subnets, IGW, NAT GW, Route Tables
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── eks/                    # EKS Cluster, Node Group, OIDC & eBPF CNI Addon
        ├── main.tf
        ├── oidc.tf
        ├── addons.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Quickstart & Provisioning

### 1. Initialize & Validate
```bash
terraform init
terraform validate
terraform fmt -check
```

### 2. Review Execution Plan
```bash
terraform plan -out=tfplan
```

### 3. Deploy Infrastructure (~12-15 minutes)
```bash
terraform apply tfplan
```

### 4. Connect `kubectl`
```bash
aws eks update-kubeconfig --region us-east-1 --name zero-trust-mlops-cluster
kubectl get nodes -o wide
kubectl get daemonset -n kube-system aws-network-policy-agent
```

### 5. Clean Teardown
```bash
terraform destroy -auto-approve
```
