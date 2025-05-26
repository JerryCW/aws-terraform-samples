# General
region = "ap-southeast-1"
tags = {
  Environment = "dev"
  Project     = "aws-terraform-samples"
  Owner       = "xxxxxxx"
  CreatedBy   = "terraform"
}

# Network - 需要替换为您的实际VPC和子网ID
vpc_id     = "vpc-xxxxxxxx"
subnet_ids = ["subnet-xxxxxx", "subnet-xxxxxxxx", "subnet-xxxxxx"]

# 自定义Pod网络 - 需要替换为您的实际Pod子网ID
enable_custom_networking = false
pod_subnet_ids           = ["subnet-pod0123456789abcdef0", "subnet-pod0123456789abcdef1", "subnet-pod0123456789abcdef2"]

# Cluster
cluster_name    = "eks-tf-demo"
cluster_version = "1.32"

# Node Groups
core_ng_instance_types = ["c7g.large"]
core_ng_ami_id         = "ami-0d93fc34fec91b6f7"  # Amazon EKS AL2023 ARM64 node image for Kubernetes 1.32
core_ng_ami_type       = "AL2023_ARM_64_STANDARD"
core_ng_min_size       = 2
core_ng_max_size       = 4
core_ng_desired_size   = 2
core_ng_disk_size      = 50

# Addons
create_addons                       = true
enable_aws_load_balancer_controller = true
enable_metrics_server               = false
enable_aws_efs_csi_driver           = false
enable_vpa                          = false

# Karpenter
enable_karpenter       = true
karpenter_helm_version = "1.3.2"

# 额外节点组配置
create_additional_nodegroups = true
additional_nodegroups = {
  app_nodegroup = {
    desired_size   = 1
    max_size       = 3
    min_size       = 1
    instance_types = ["m7g.large"]
    ami_type       = "AL2023_ARM_64_STANDARD"
    capacity_type  = "ON_DEMAND"
    disk_size      = 50
    labels = {
      "role" = "application"
      "app"  = "demo"
    }
    taints = {}
    additional_policies = {
      AmazonS3ReadOnlyAccess = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }
    tags = {
      "NodeGroup" = "application"
    }
  }
  
  spot_nodegroup = {
    desired_size   = 0
    max_size       = 5
    min_size       = 0
    instance_types = ["c7g.medium", "c7g.large"]
    ami_type       = "AL2023_ARM_64_STANDARD"
    capacity_type  = "SPOT"
    disk_size      = 50
    labels = {
      "role" = "worker"
      "instance-type" = "spot"
    }
    taints = {
      "spot" = {
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      }
    }
    additional_policies = {}
    tags = {
      "NodeGroup" = "spot-workers"
    }
  }
}
# Karpenter 示例配置
create_karpenter_examples = true
