################################################################################
# EKS Blueprints Addons
################################################################################

module "eks_blueprints_addons" {
  count = var.create_addons ? 1 : 0
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.19"

  # 明确依赖于EKS集群
  depends_on = [
    module.eks
  ]

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  # Install aws-ebs-csi-driver
  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
      values = [
        <<-EOT
        tolerations:
          - key: "${var.cluster_name}.cluster/CoreService"
            operator: Equal
            value: "true"
            effect: PreferNoSchedule
        EOT
     ]
    }
  }

  # Install aws_load_balancer_controller 
  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller
  aws_load_balancer_controller = {
    values = [
        <<-EOT
        tolerations:
          - key: "${var.cluster_name}.cluster/CoreService"
            operator: Equal
            value: "true"
            effect: PreferNoSchedule
        EOT
    ]
    set = [
      {
        name  = "vpcId"
        value = var.vpc_id
      },
      {
        name  = "podDisruptionBudget.maxUnavailable"
        value = 1
      }
    ]
  }

  # Install aws_efs_csi_driver
  enable_aws_efs_csi_driver = var.enable_aws_efs_csi_driver
  aws_efs_csi_driver = {
    values = [
        <<-EOT
        tolerations:
          - key: "${var.cluster_name}.cluster/CoreService"
            operator: Equal
            value: "true"
            effect: PreferNoSchedule
        EOT
    ]
  }

  # Install metrics_server
  enable_metrics_server = var.enable_metrics_server
  metrics_server = {
    values = [
        <<-EOT
        tolerations:
          - key: "${var.cluster_name}.cluster/CoreService"
            operator: Equal
            value: "true"
            effect: PreferNoSchedule
        EOT
    ]
  }

  # Install vpa
  enable_vpa = var.enable_vpa
  vpa = {
    values = [
        <<-EOT
        tolerations:
          - key: "${var.cluster_name}.cluster/CoreService"
            operator: Equal
            value: "true"
            effect: PreferNoSchedule
        EOT
    ]
  }

  tags = var.tags
}
