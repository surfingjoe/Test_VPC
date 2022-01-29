provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "all" {}

terraform {
  backend "s3" {
    bucket = "surfingjoes-terraform-states"
    key    = "deployment_test-terraform.tfstate"
    region = "us-west-1"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" { }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">=3.6.0"

  name = "${var.environment}-vpc"
  cidr                  = var.vpc_cidr_block
  azs                   = data.aws_availability_zones.available.names
  private_subnets       = Test-slice(var.private_subnet_cidr_blocks, 0, 2)
  public_subnets        = slice(var.public_subnet_cidr_blocks, 0, 2)
  #intra_subnets         = slice(var.intra_subnet_cidr_blocks, 0, 2)
  #database_subnets      = slice(var.database_subnet_cidr_blocks, 0, 2)
  enable_dns_support    = true
  enable_dns_hostnames  = true
  enable_nat_gateway    = false
  enable_vpn_gateway    = false
  single_nat_gateway    = false
    tags = {
    Name                = "${var.environment}-VPC"
    Stage               = "${var.environment}"
    Owner               = "${var.your_name}"
  }
}