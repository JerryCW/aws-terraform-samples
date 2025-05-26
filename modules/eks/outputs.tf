################################################################################
# Cluster Outputs
################################################################################

output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = module.eks.cluster_version
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = module.eks.cluster_iam_role_arn
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without protocol)"
  value       = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = module.eks.oidc_provider_arn
}

output "cluster_security_group_id" {
  description = "ID of the cluster security group"
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = module.eks.node_security_group_id
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${data.aws_region.current.name} --name ${module.eks.cluster_name}"
}

################################################################################
# Node Groups Outputs
################################################################################

output "eks_managed_node_groups" {
  description = "EKS managed node groups"
  value       = module.eks.eks_managed_node_groups
}

output "core_node_group_id" {
  description = "ID of the core node group"
  value       = module.eks.eks_managed_node_groups["core_services_ng"].node_group_id
}

output "core_node_group_arn" {
  description = "ARN of the core node group"
  value       = module.eks.eks_managed_node_groups["core_services_ng"].node_group_arn
}

output "node_group_role_arn" {
  description = "ARN of the node group IAM role"
  value       = module.eks.eks_managed_node_groups["core_services_ng"].iam_role_arn
}

################################################################################
# Custom Networking Outputs
################################################################################

output "custom_networking_enabled" {
  description = "Whether custom networking is enabled"
  value       = var.enable_custom_networking
}

output "eni_configs" {
  description = "ENI configs created for custom networking"
  value       = var.enable_custom_networking ? kubectl_manifest.eni_config : null
}

################################################################################
# Addons Outputs
################################################################################

output "aws_load_balancer_controller_enabled" {
  description = "Whether AWS Load Balancer Controller is enabled"
  value       = var.create_addons && var.enable_aws_load_balancer_controller
}

output "metrics_server_enabled" {
  description = "Whether Metrics Server is enabled"
  value       = var.create_addons && var.enable_metrics_server
}

output "aws_efs_csi_driver_enabled" {
  description = "Whether AWS EFS CSI Driver is enabled"
  value       = var.create_addons && var.enable_aws_efs_csi_driver
}

output "vpa_enabled" {
  description = "Whether Vertical Pod Autoscaler is enabled"
  value       = var.create_addons && var.enable_vpa
}

################################################################################
# Karpenter Outputs
################################################################################

output "karpenter_enabled" {
  description = "Whether Karpenter is enabled"
  value       = var.enable_karpenter
}

output "karpenter_irsa_arn" {
  description = "ARN of the Karpenter IRSA role"
  value       = var.enable_karpenter ? module.karpenter[0].iam_role_arn : null
}

output "karpenter_node_role_arn" {
  description = "ARN of the Karpenter node IAM role"
  value       = var.enable_karpenter ? module.karpenter[0].node_iam_role_arn : null
}

output "karpenter_queue_name" {
  description = "Name of the Karpenter SQS queue"
  value       = var.enable_karpenter ? module.karpenter[0].queue_name : null
}
################################################################################
# Additional Node Groups Outputs
################################################################################

output "additional_nodegroups" {
  description = "Map of additional node groups created and their attributes"
  value       = var.create_additional_nodegroups ? aws_eks_node_group.additional_nodegroups : {}
}

output "additional_nodegroup_iam_roles" {
  description = "Map of IAM roles created for additional node groups"
  value       = var.create_additional_nodegroups ? aws_iam_role.additional_nodegroup_role : {}
}
