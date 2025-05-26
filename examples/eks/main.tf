################################################################################
# EKS Custom Networking Example
################################################################################

provider "aws" {
  region = var.region
}

# 获取EKS集群认证信息
data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster_auth.token
  }
}

provider "kubectl" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  load_config_file       = false
}

################################################################################
# EKS Cluster with Custom Networking
################################################################################

module "eks" {
  source = "../../modules/eks"
  
  # 集群配置
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  
  # 网络配置
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  
  # 自定义Pod网络配置
  enable_custom_networking = var.enable_custom_networking
  pod_subnet_ids           = var.pod_subnet_ids
  
  # 节点组配置
  core_ng_instance_types = var.core_ng_instance_types
  core_ng_ami_id         = var.core_ng_ami_id
  core_ng_ami_type       = var.core_ng_ami_type
  core_ng_min_size       = var.core_ng_min_size
  core_ng_max_size       = var.core_ng_max_size
  core_ng_desired_size   = var.core_ng_desired_size
  core_ng_disk_size      = var.core_ng_disk_size
  
  # 额外节点组配置
  create_additional_nodegroups = var.create_additional_nodegroups
  additional_nodegroups        = var.additional_nodegroups
  
  # 附加组件配置
  create_addons                       = var.create_addons
  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller
  enable_metrics_server               = var.enable_metrics_server
  enable_aws_efs_csi_driver           = var.enable_aws_efs_csi_driver
  enable_vpa                          = var.enable_vpa
  
  # Karpenter配置
  enable_karpenter       = var.enable_karpenter
  karpenter_helm_version = var.karpenter_helm_version
  
  # 标签
  tags = var.tags
}
