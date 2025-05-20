################################################################################
# Karpenter - 单独管理，避免循环依赖
################################################################################

module "karpenter" {
  count = var.enable_karpenter ? 1 : 0
  source = "terraform-aws-modules/eks/aws//modules/karpenter"

  # 明确依赖于EKS集群和附加组件
  depends_on = [
    module.eks,
    module.eks_blueprints_addons
  ]

  cluster_name          = module.eks.cluster_name
  enable_v1_permissions = true
  namespace             = "karpenter"

  # Name needs to match role name passed to the EC2NodeClass
  node_iam_role_use_name_prefix   = false
  node_iam_role_name              = "KarpenterNodeRole-${var.cluster_name}"

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    AmazonSSMPatchAssociation    = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
  }

  enable_irsa                     = true
  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn

  iam_role_use_name_prefix = false
  iam_role_name            = "KarpenterController-${var.cluster_name}"
}

################################################################################
# Karpenter Helm chart
################################################################################

resource "helm_release" "karpenter" {
  count               = var.enable_karpenter ? 1 : 0
  name                = "karpenter"
  namespace           = "karpenter"
  create_namespace    = true
  repository          = "oci://public.ecr.aws/karpenter"
  chart               = "karpenter"
  version             = var.karpenter_helm_version
  wait                = false

  # 确保在Karpenter IAM角色创建后再安装Helm chart
  depends_on = [
    module.karpenter
  ]

  values = [
    <<-EOT
    nodeSelector:
      karpenter.sh/controller: 'true'
    dnsPolicy: Default
    settings:
      clusterName: ${module.eks.cluster_name}
      clusterEndpoint: ${module.eks.cluster_endpoint}
      interruptionQueue: ${module.karpenter[0].queue_name}
    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: ${module.karpenter[0].iam_role_arn}
    webhook:
      enabled: false
    EOT
  ]
}
