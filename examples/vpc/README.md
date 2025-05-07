# VPC Example

This example demonstrates how to use the VPC module to create a complete VPC infrastructure in AWS.

## Features

This example creates:
- A VPC with configurable CIDR block
- Public and private subnets across multiple availability zones
- Internet Gateway for public subnets
- NAT Gateway for private subnets
- S3 VPC Endpoint
- Appropriate route tables and associations
- Kubernetes-compatible subnet tagging

## Usage

To run this example, execute:

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

# Clean up when done
terraform destroy
```

## Customization

You can customize this example by modifying the `terraform.tfvars` file or by providing variables at runtime:

```bash
terraform apply -var="aws_region=us-west-2" -var="env_prefix=test"
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| env_prefix | Environment prefix for resource naming | `string` | `"example"` | no |
| aws_region | AWS region where resources will be created | `string` | `"ap-southeast-1"` | no |
| vpc_cidr_block | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| secondary_cidr_blocks | Secondary CIDR blocks for the VPC | `list(string)` | `["100.64.0.0/16"]` | no |
| private_subnet_cidr_blocks | CIDR blocks for the private subnets | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` | no |
| public_subnet_cidr_blocks | CIDR blocks for the public subnets | `list(string)` | `["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]` | no |
| aws_azs | Availability zones for the subnets | `list(string)` | `["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]` | no |
| enable_nat_gateway | Whether to enable NAT Gateway | `bool` | `true` | no |
| single_nat_gateway | Whether to use a single NAT Gateway for all private subnets | `bool` | `true` | no |
| create_vpc_endpoints | Whether to create VPC endpoints | `bool` | `true` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{ Environment = "example", Terraform = "true", Project = "aws-terraform-samples" }` | no |

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
| vpc_endpoint_s3_id | S3 VPC Endpoint ID |
