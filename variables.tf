################################################################################
#     环境变量
################################################################################

variable "env_prefix" {
  description = "环境前缀，用于资源命名"
  type        = string
}

variable "aws_region" {
  description = "AWS区域"
  type        = string
}

variable "common_tags" {
  description = "应用到所有资源的通用标签"
  type        = map(string)
  default     = {}
}

################################################################################
#     VPC基本配置
################################################################################

variable "vpc_cidr_block" {
  description = "VPC的CIDR块"
  type        = string
}

variable "secondary_cidr_blocks" {
  description = "VPC的次要CIDR块"
  type        = list(string)
  default     = []
}

variable "aws_azs" {
  description = "子网使用的可用区列表"
  type        = list(string)
}

################################################################################
#     子网配置
################################################################################

variable "private_subnet_cidr_blocks" {
  description = "私有子网的CIDR块（用于应用服务，无直接互联网访问）"
  type        = list(string)
}

variable "public_subnet_cidr_blocks" {
  description = "公有子网的CIDR块（有直接互联网访问）"
  type        = list(string)
}

################################################################################
#     网关配置
################################################################################

variable "enable_nat_gateway" {
  description = "是否创建NAT网关"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "是否只创建一个NAT网关（用于所有AZ）"
  type        = bool
  default     = true
}

variable "enable_internet_gateway" {
  description = "是否创建互联网网关"
  type        = bool
  default     = true
}

################################################################################
#     VPC端点配置
################################################################################

variable "vpc_endpoints" {
  description = "要创建的VPC端点配置"
  type        = map(any)
  default     = null
}
