################################################################################
##### VPC
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.17"

  cidr                  = var.vpc_cidr_block
  secondary_cidr_blocks = var.secondary_cidr_blocks
  azs                   = var.aws_azs
  private_subnets       = var.private_subnet_cidr_blocks
  public_subnets        = var.public_subnet_cidr_blocks

  # 配置公有子网的Tag
  public_subnet_tags = merge(
    {
      "kubernetes.io/role/elb" = 1
    },
    var.common_tags
  )
  
  public_subnet_tags_per_az = {
    "${var.aws_region}a" = {
      Name : "${var.env_prefix}-${var.aws_region}a-public-subnet"
    },
    "${var.aws_region}b" = {
      Name : "${var.env_prefix}-${var.aws_region}b-public-subnet"
    },
    "${var.aws_region}c" = {
      Name : "${var.env_prefix}-${var.aws_region}c-public-subnet"
    }
  }

  # 配置私有子网的Tag
  private_subnet_tags = merge(
    {
      "kubernetes.io/role/internal-elb" = 1
    },
    var.common_tags
  )

  private_subnet_tags_per_az = {
    "${var.aws_region}a" = {
      Name : "${var.env_prefix}-${var.aws_region}a-private-subnet"
    },
    "${var.aws_region}b" = {
      Name : "${var.env_prefix}-${var.aws_region}b-private-subnet"
    },
    "${var.aws_region}c" = {
      Name : "${var.env_prefix}-${var.aws_region}c-private-subnet"
    }
  }

  default_route_table_tags = merge(
    {
      Name = "${var.env_prefix}-rtb-default"
    },
    var.common_tags
  )

  public_route_table_tags = merge(
    {
      Name = "${var.env_prefix}-rtb-public"
    },
    var.common_tags
  )

  private_route_table_tags = merge(
    {
      Name = "${var.env_prefix}-rtb-private"
    },
    var.common_tags
  )

  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway  = var.single_nat_gateway
  nat_gateway_tags = merge(
    {
      Name = "${var.env_prefix}-nat"
    },
    var.common_tags
  )

  create_igw = var.enable_internet_gateway
  igw_tags = merge(
    {
      Name = "${var.env_prefix}-igw"
    },
    var.common_tags
  )

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    {
      Name = "${var.env_prefix}-vpc"
    },
    var.common_tags
  )
}

module "vpc_endpoint" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.17"

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
      route_table_ids = flatten([module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])

      tags = merge(
        {
          Name = "${var.env_prefix}-s3-gateway-endpoint"
        },
        var.common_tags
      )
    }
  }
}