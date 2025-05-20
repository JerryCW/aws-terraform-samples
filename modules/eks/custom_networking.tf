################################################################################
# Custom Pod Networking
################################################################################

# 获取Pod子网信息
data "aws_subnet" "pod_subnets" {
  for_each = var.enable_custom_networking ? toset(var.pod_subnet_ids) : toset([])
  id       = each.value
}

locals {
  # 创建可用区到子网ID的映射
  azs_to_subnets = var.enable_custom_networking ? zipmap(
    [for subnet in data.aws_subnet.pod_subnets : subnet.availability_zone],
    [for subnet in data.aws_subnet.pod_subnets : subnet.id]
  ) : {}
}

# 配置 POD Custom Network
resource "kubectl_manifest" "eni_config" {
  for_each = local.azs_to_subnets
  yaml_body = yamlencode({
    apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
    kind       = "ENIConfig"
    metadata   = {
      name = each.key
    }
    spec = {
      securityGroups = [
        module.eks.node_security_group_id,
      ]
      subnet = each.value
    }
  })

  depends_on = [
    module.eks
  ]
}
