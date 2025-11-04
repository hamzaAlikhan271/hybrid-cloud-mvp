# AWS Hybrid Cloud MVP: Core Networking Stack

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

#################################################
# VPC: Shared Services
#################################################
module "vpc_shared" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "shared-services"
  cidr = var.shared_vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets  = ["10.10.101.0/24", "10.10.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = var.default_tags
}

#################################################
# VPC: Production
#################################################
module "vpc_prod" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "production"
  cidr = var.prod_vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24"]
  public_subnets  = ["10.20.101.0/24", "10.20.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = var.default_tags
}

#################################################
# VPC: Disaster Recovery
#################################################
module "vpc_dr" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "dr"
  cidr = var.dr_vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.30.1.0/24", "10.30.2.0/24"]
  public_subnets  = ["10.30.101.0/24", "10.30.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = var.default_tags
}

#################################################
# Transit Gateway
#################################################
resource "aws_ec2_transit_gateway" "tgw" {
  description = "Hybrid-TGW"
  tags        = var.default_tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "attach_shared" {
  subnet_ids         = module.vpc_shared.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = module.vpc_shared.vpc_id
  tags               = var.default_tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "attach_prod" {
  subnet_ids         = module.vpc_prod.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = module.vpc_prod.vpc_id
  tags               = var.default_tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "attach_dr" {
  subnet_ids         = module.vpc_dr.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = module.vpc_dr.vpc_id
  tags               = var.default_tags
}

