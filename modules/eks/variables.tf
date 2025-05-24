################################################################################
# General Variables
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
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
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "cluster_endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Indicates whether the cluster creator IAM principal has admin permissions in the cluster"
  type        = bool
  default     = true
}

variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

variable "create_cloudwatch_log_group" {
  description = "Determines whether a CloudWatch log group is created for each enabled log type"
  type        = bool
  default     = true
}

################################################################################
# Custom Networking Variables
################################################################################

variable "enable_custom_networking" {
  description = "Whether to enable custom networking for pods"
  type        = bool
  default     = false
}

variable "pod_subnet_ids" {
  description = "List of subnet IDs for pod ENIs when using custom networking"
  type        = list(string)
  default     = []
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
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, AL2023_x86_64_STANDARD, AL2023_ARM_64_STANDARD"
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
  default     = 2
}

variable "core_ng_desired_size" {
  description = "Desired number of nodes in the core node group"
  type        = number
  default     = 2
}

variable "core_ng_disk_size" {
  description = "Disk size in GB for core node group instances"
  type        = number
  default     = 20
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
