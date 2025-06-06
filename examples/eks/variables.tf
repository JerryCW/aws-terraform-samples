################################################################################
# General Variables
################################################################################

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Network Variables
################################################################################

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

################################################################################
# Custom Networking Variables
################################################################################

variable "enable_custom_networking" {
  description = "Whether to enable custom networking for pods"
  type        = bool
  default     = true
}

variable "pod_subnet_ids" {
  description = "List of subnet IDs for pod ENIs when using custom networking"
  type        = list(string)
}

################################################################################
# Cluster Variables
################################################################################

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.32"
}

################################################################################
# Node Groups Variables
################################################################################

variable "core_ng_instance_types" {
  description = "List of instance types for the core node group"
  type        = list(string)
  default     = ["c7i.large"]
}

variable "core_ng_ami_id" {
  description = "AMI ID to use for the EKS node group. If not specified, the EKS optimized AMI will be used."
  type        = string
  default     = ""
}

variable "core_ng_ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, AL2023_x86_64_STANDARD, AL2023_ARM64_STANDARD"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "core_ng_min_size" {
  description = "Minimum number of nodes in the core node group"
  type        = number
  default     = 2
}

variable "core_ng_max_size" {
  description = "Maximum number of nodes in the core node group"
  type        = number
  default     = 4
}

variable "core_ng_desired_size" {
  description = "Desired number of nodes in the core node group"
  type        = number
  default     = 2
}

variable "core_ng_disk_size" {
  description = "Disk size in GB for core node group instances"
  type        = number
  default     = 50
}

################################################################################
# Addons Variables
################################################################################

variable "create_addons" {
  description = "Whether to create addons"
  type        = bool
  default     = true
}

variable "enable_aws_load_balancer_controller" {
  description = "Enable AWS Load Balancer Controller"
  type        = bool
  default     = true
}

variable "enable_metrics_server" {
  description = "Enable Metrics Server"
  type        = bool
  default     = true
}

variable "enable_aws_efs_csi_driver" {
  description = "Enable AWS EFS CSI Driver"
  type        = bool
  default     = false
}

variable "enable_vpa" {
  description = "Enable Vertical Pod Autoscaler"
  type        = bool
  default     = false
}

################################################################################
# Karpenter Variables
################################################################################

variable "enable_karpenter" {
  description = "Enable Karpenter"
  type        = bool
  default     = false
}

variable "karpenter_helm_version" {
  description = "Karpenter Helm chart version"
  type        = string
  default     = "1.3.2"
}

################################################################################
# Additional Node Groups Variables
################################################################################

variable "create_additional_nodegroups" {
  description = "Whether to create additional node groups"
  type        = bool
  default     = false
}

variable "additional_nodegroups" {
  description = "Map of additional node group configurations"
  type        = map(any)
  default     = {}
}
################################################################################
# Karpenter Example Variables
################################################################################

variable "create_karpenter_examples" {
  description = "Whether to create Karpenter example deployments"
  type        = bool
  default     = false
}
