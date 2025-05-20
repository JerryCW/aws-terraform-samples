################################################################################
# EKS Module - Based on AlphaProject approach
################################################################################

# 获取当前区域
data "aws_region" "current" {}

# 获取 VPC 信息
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# 为私有子网添加karpenter的discovery标签
resource "aws_ec2_tag" "private_subnet_tags" {
  for_each    = toset(var.subnet_ids)
  resource_id = each.value
  key         = "karpenter.sh/discovery"
  value       = var.cluster_name
}

################################################################################
# EKS Cluster
################################################################################

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.24"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids
  
  # Give the Terraform identity admin access to the cluster
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions
  cluster_endpoint_public_access           = var.cluster_endpoint_public_access

  # Enable Log
  cluster_enabled_log_types       = var.cluster_enabled_log_types
  create_cloudwatch_log_group     = var.create_cloudwatch_log_group

  # Enable IRSA
  enable_irsa = true

  # Core Addon
  cluster_addons = {
    coredns = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
      configuration_values = jsonencode({
        tolerations = [
          {
            key    = "${var.cluster_name}.cluster/CoreService"
            value  = "true"
            effect = "PreferNoSchedule"
          }
        ]
      })
    }
    kube-proxy = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      before_compute    = true
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
      # 如果启用自定义网络，配置VPC CNI
      configuration_values = var.enable_custom_networking ? jsonencode({
        env = {
          AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
          ENI_CONFIG_LABEL_DEF               = "topology.kubernetes.io/zone"
        }
      }) : null
    }
    eks-pod-identity-agent = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
  }

  # 为Karpenter添加发现标签
  node_security_group_tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }

  # 托管节点组
  eks_managed_node_groups = {  
    # Create Node Group for Core Services 
    core_services_ng = {
      # Node Group Name
      use_name_prefix            = false
      use_custom_launch_template = false

      # Create Node Group Role
      create_iam_role            = true
      iam_role_name              = "CoreServiceNodeGroupRole-${var.cluster_name}"
      iam_role_use_name_prefix   = false

      # 添加SSM权限
      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        AmazonSSMPatchAssociation    = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
      }

      instance_types             = var.core_ng_instance_types
      min_size                   = var.core_ng_min_size
      max_size                   = var.core_ng_max_size
      desired_size               = var.core_ng_desired_size
      
      # Enable Detailed Monitoring
      enable_monitoring          = true

      ebs_optimized              = true
    
      block_device_mappings = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = var.core_ng_disk_size
          volume_type           = "gp3"
          delete_on_termination = true
        }
      }

      update_config = {
        max_unavailable_percentage = 50
      }

      labels = {
        # Used to ensure Karpenter runs on nodes that it does not manage
        "${var.cluster_name}.cluster/CoreService" = "true"
        "karpenter.sh/controller" = "true"
      }

      taints = {
        # The pods that do not tolerate this taint should run on nodes
        # created by Karpenter
        CoreService = {
          key    = "${var.cluster_name}.cluster/CoreService"
          value  = "true"
          effect = "PREFER_NO_SCHEDULE"
        }
      }
      
      tags = merge(
        var.tags,
        {
          Name = "Core-Services-NG"
        }
      )
    }
  }

  tags = var.tags
}
