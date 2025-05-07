# AWS Terraform Samples

This repository contains sample Terraform configurations for AWS resources. It is organized as follows:

## Directory Structure

- `modules/`: Reusable Terraform modules
  - `vpc/`: VPC module for creating networking infrastructure
  - (more modules will be added)
- `examples/`: Example implementations using the modules
  - `vpc/`: Example VPC configuration
  - (more examples will be added)

## Getting Started

1. Clone this repository
2. Navigate to the desired example directory
3. Run `terraform init` to initialize the Terraform configuration
4. Run `terraform plan` to see the execution plan
5. Run `terraform apply` to apply the changes

## Available Modules

### VPC Module

The VPC module creates a complete networking infrastructure including:
- VPC with configurable CIDR block
- Public and private subnets across multiple availability zones
- Internet Gateway for public subnets
- NAT Gateway for private subnets
- S3 VPC Endpoint
- Appropriate route tables and associations

See the [module documentation](modules/vpc/README.md) for more details.

## Prerequisites

- Terraform v1.0.0+
- AWS CLI configured with appropriate credentials
- Basic knowledge of AWS services and Terraform

## License

This project is licensed under the MIT License - see the LICENSE file for details.
