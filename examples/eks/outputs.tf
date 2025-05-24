################################################################################
# Outputs
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

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = module.eks.configure_kubectl
}

output "core_node_group_id" {
  description = "ID of the core node group"
  value       = module.eks.eks_managed_node_groups.core_services_ng.node_group_id
}

output "custom_networking_enabled" {
  description = "Whether custom networking is enabled"
  value       = module.eks.custom_networking_enabled
}

output "aws_load_balancer_controller_enabled" {
  description = "Whether AWS Load Balancer Controller is enabled"
  value       = module.eks.aws_load_balancer_controller_enabled
}

output "metrics_server_enabled" {
  description = "Whether Metrics Server is enabled"
  value       = module.eks.metrics_server_enabled
}

output "aws_efs_csi_driver_enabled" {
  description = "Whether AWS EFS CSI Driver is enabled"
  value       = module.eks.aws_efs_csi_driver_enabled
}

output "vpa_enabled" {
  description = "Whether VPA is enabled"
  value       = module.eks.vpa_enabled
}

output "karpenter_enabled" {
  description = "Whether Karpenter is enabled"
  value       = module.eks.karpenter_enabled
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = var.vpc_id
}

output "subnet_ids" {
  description = "List of subnet IDs used for the EKS cluster"
  value       = var.subnet_ids
}

output "pod_subnet_ids" {
  description = "List of subnet IDs used for pod ENIs"
  value       = var.pod_subnet_ids
}



