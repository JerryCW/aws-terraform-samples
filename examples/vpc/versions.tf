terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
  
  backend "s3" {
    bucket         = "demo-aws-terraform-tfstate"
    key            = "examples/vpc/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "aws-terraform-locks"
    encrypt        = true
  }
}
