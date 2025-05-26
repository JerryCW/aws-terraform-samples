################################################################################
# Additional Node Groups for EKS Cluster
################################################################################

resource "aws_eks_node_group" "additional_nodegroups" {
  for_each = var.create_additional_nodegroups ? tomap(var.additional_nodegroups) : {}

  # 节点组名称
  node_group_name = each.key
  cluster_name    = module.eks.cluster_name
  
  # 使用现有的节点角色或创建新角色
  node_role_arn   = try(each.value.node_role_arn, aws_iam_role.additional_nodegroup_role[each.key].arn)
  
  # 子网配置
  subnet_ids      = try(each.value.subnet_ids, var.subnet_ids)
  
  # 扩缩容配置
  scaling_config {
    desired_size  = try(each.value.desired_size, 1)
    max_size      = try(each.value.max_size, 3)
    min_size      = try(each.value.min_size, 1)
  }
  
  # 实例配置
  ami_type        = try(each.value.ami_type, "AL2023_x86_64_STANDARD")
  capacity_type   = try(each.value.capacity_type, "ON_DEMAND")
  instance_types  = try(each.value.instance_types, ["m6i.large"])
  disk_size       = try(each.value.disk_size, 50)
  
  # 更新配置
  update_config {
    max_unavailable_percentage = try(each.value.max_unavailable_percentage, 50)
  }
  
  # 标签
  labels = try(each.value.labels, {})
  
  # 污点
  dynamic "taint" {
    for_each = try(each.value.taints, {})
    
    content {
      key    = taint.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }
  
  # # 远程访问
  # dynamic "remote_access" {
  #   for_each = try(each.value.remote_access, null) != null ? [each.value.remote_access] : []
    
  #   content {
  #     ec2_ssh_key               = try(remote_access.value.ec2_ssh_key, null)
  #     source_security_group_ids = try(remote_access.value.source_security_group_ids, null)
  #   }
  # }
  
  # # 启动模板
  # dynamic "launch_template" {
  #   for_each = try(each.value.launch_template, null) != null ? [each.value.launch_template] : []
    
  #   content {
  #     id      = try(launch_template.value.id, null)
  #     name    = try(launch_template.value.name, null)
  #     version = try(launch_template.value.version, null)
  #   }
  # }
  
  # 依赖于EKS集群
  depends_on = [
    module.eks
  ]
  
  # 标签
  tags = merge(
    var.tags,
    try(each.value.tags, {}),
    {
      "Name" = each.key
    }
  )
  
  # 生命周期
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# 为额外节点组创建IAM角色
resource "aws_iam_role" "additional_nodegroup_role" {
  for_each = var.create_additional_nodegroups ? tomap(var.additional_nodegroups) : {}
  
  name = try(each.value.iam_role_name, "${each.key}-role-${var.cluster_name}")
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  
  tags = merge(
    var.tags,
    try(each.value.tags, {}),
    {
      "Name" = try(each.value.iam_role_name, "${each.key}-role-${var.cluster_name}")
    }
  )
}

# 附加EKS工作节点策略
resource "aws_iam_role_policy_attachment" "additional_nodegroup_AmazonEKSWorkerNodePolicy" {
  for_each = var.create_additional_nodegroups ? tomap(var.additional_nodegroups) : {}
  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.additional_nodegroup_role[each.key].name
}

# 附加EKS CNI策略
resource "aws_iam_role_policy_attachment" "additional_nodegroup_AmazonEKS_CNI_Policy" {
  for_each = var.create_additional_nodegroups ? tomap(var.additional_nodegroups) : {}
  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.additional_nodegroup_role[each.key].name
}

# 附加EC2容器注册策略
resource "aws_iam_role_policy_attachment" "additional_nodegroup_AmazonEC2ContainerRegistryReadOnly" {
  for_each = var.create_additional_nodegroups ? tomap(var.additional_nodegroups) : {}
  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.additional_nodegroup_role[each.key].name
}

# 附加SSM策略
resource "aws_iam_role_policy_attachment" "additional_nodegroup_AmazonSSMManagedInstanceCore" {
  for_each = var.create_additional_nodegroups ? tomap(var.additional_nodegroups) : {}
  
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.additional_nodegroup_role[each.key].name
}

# 附加SSM策略
resource "aws_iam_role_policy_attachment" "additional_nodegroup_AmazonSSMPatchAssociation" {
  for_each = var.create_additional_nodegroups ? tomap(var.additional_nodegroups) : {}
  
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
  role       = aws_iam_role.additional_nodegroup_role[each.key].name
}

# 附加额外的IAM策略
resource "aws_iam_role_policy_attachment" "additional_nodegroup_additional_policies" {
  for_each = var.create_additional_nodegroups ? {
    for policy in flatten([
      for ng_key, ng in tomap(var.additional_nodegroups) : [
        for policy_key, policy_arn in try(ng.additional_policies, {}) : {
          ng_key     = ng_key
          policy_key = policy_key
          policy_arn = policy_arn
        }
      ]
    ]) : "${policy.ng_key}-${policy.policy_key}" => policy
  } : {}
  
  policy_arn = each.value.policy_arn
  role       = aws_iam_role.additional_nodegroup_role[each.value.ng_key].name
}
