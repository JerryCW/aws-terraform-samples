################################################################################
##### VPC Endpoints
################################################################################

module "vpc_endpoint" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.17"
  
  # 只有在启用VPC Endpoints时才创建
  create = var.create_vpc_endpoints

  vpc_id = module.vpc.vpc_id

  create_security_group      = true
  security_group_name_prefix = "${var.env_prefix}-vpc-endpoints-"
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }

  endpoints = {
    s3 = {
      service             = "s3"
      service_type        = "Gateway"
      private_dns_enabled = true
      route_table_ids     = flatten([module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])

      tags = merge(
        var.tags,
        {
          Name = "${var.env_prefix}-s3-gateway-endpoint"
        }
      )
    }
  }
}
