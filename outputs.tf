################################################################################
#     VPC输出
################################################################################

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR块"
  value       = module.vpc.vpc_cidr_block
}

################################################################################
#     子网输出
################################################################################

output "private_subnets" {
  description = "私有子网ID列表"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "公有子网ID列表"
  value       = module.vpc.public_subnets
}

output "availability_zones" {
  description = "可用区列表"
  value       = module.vpc.availability_zones
}

################################################################################
#     网关输出
################################################################################

output "internet_gateway_id" {
  description = "互联网网关ID"
  value       = module.vpc.igw_id
}

output "nat_gateway_ids" {
  description = "NAT网关ID列表"
  value       = module.vpc.nat_ids
}

output "nat_gateway_public_ips" {
  description = "NAT网关公网IP列表"
  value       = module.vpc.nat_public_ips
}

################################################################################
#     VPC端点输出
################################################################################

output "vpc_endpoint_s3_id" {
  description = "S3 VPC端点ID"
  value       = module.vpc.vpc_endpoint_s3_id
}