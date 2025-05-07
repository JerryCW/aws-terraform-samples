################################################################################
#     ENV Variables
################################################################################

variable "env_prefix" {
  description = "Environment prefix for resource naming (e.g., dev, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

################################################################################
#     VPC Variables
################################################################################

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "secondary_cidr_blocks" {
  description = "Secondary CIDR blocks for the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "aws_azs" {
  description = "Availability zones for the subnets"
  type        = list(string)
}

################################################################################
#     VPC Features
################################################################################

variable "enable_nat_gateway" {
  description = "Whether to enable NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to use a single NAT Gateway for all private subnets"
  type        = bool
  default     = true
}

variable "create_vpc_endpoints" {
  description = "Whether to create VPC endpoints"
  type        = bool
  default     = true
}

################################################################################
#     Tags
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
