################################################################################
#     VPC Outputs
################################################################################

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = module.vpc.azs
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = try(module.vpc.natgw_ids[0], null)
}

output "nat_gateway_public_ip" {
  description = "NAT Gateway Public IP"
  value       = module.vpc.nat_public_ips
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.igw_id
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  description = "List of public route table IDs"
  value       = module.vpc.public_route_table_ids
}

################################################################################
#     VPC Endpoint Outputs
################################################################################

output "vpc_endpoint_s3_id" {
  description = "S3 VPC Endpoint ID"
  value       = var.create_vpc_endpoints ? module.vpc_endpoint.endpoints["s3"].id : null
}
