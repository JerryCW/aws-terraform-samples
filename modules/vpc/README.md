# AWS VPC Terraform Module

This module creates a VPC with public and private subnets across multiple availability zones.

## Features

- Creates a VPC with configurable CIDR block
- Creates public and private subnets across multiple availability zones
- Configures Internet Gateway for public subnets
- Configures NAT Gateway for private subnets (optional)
- Creates S3 VPC Endpoint (optional)
- Adds appropriate tags for Kubernetes integration

## Usage

```hcl
module "vpc" {
  source = "../../modules/vpc"

  env_prefix                = "dev"
  aws_region                = "us-west-2"
  vpc_cidr_block            = "10.0.0.0/16"
  secondary_cidr_blocks     = ["100.64.0.0/16"]
  private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnet_cidr_blocks  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  aws_azs                   = ["us-west-2a", "us-west-2b", "us-west-2c"]
  
  enable_nat_gateway        = true
  single_nat_gateway        = true
  create_vpc_endpoints      = true
  
  tags = {
    Environment = "dev"
    Project     = "example"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| env_prefix | Environment prefix for resource naming | `string` | n/a | yes |
| aws_region | AWS region where resources will be created | `string` | n/a | yes |
| vpc_cidr_block | CIDR block for the VPC | `string` | n/a | yes |
| secondary_cidr_blocks | Secondary CIDR blocks for the VPC | `list(string)` | `[]` | no |
| private_subnet_cidr_blocks | CIDR blocks for the private subnets | `list(string)` | n/a | yes |
| public_subnet_cidr_blocks | CIDR blocks for the public subnets | `list(string)` | n/a | yes |
| aws_azs | Availability zones for the subnets | `list(string)` | n/a | yes |
| enable_nat_gateway | Whether to enable NAT Gateway | `bool` | `true` | no |
| single_nat_gateway | Whether to use a single NAT Gateway for all private subnets | `bool` | `true` | no |
| create_vpc_endpoints | Whether to create VPC endpoints | `bool` | `true` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| vpc_cidr_block | VPC CIDR block |
| private_subnets | List of private subnet IDs |
| public_subnets | List of public subnet IDs |
| availability_zones | List of availability zones used |
| nat_gateway_id | NAT Gateway ID |
| nat_gateway_public_ip | NAT Gateway Public IP |
| internet_gateway_id | Internet Gateway ID |
| private_route_table_ids | List of private route table IDs |
| public_route_table_ids | List of public route table IDs |
| vpc_endpoint_s3_id | S3 VPC Endpoint ID |
