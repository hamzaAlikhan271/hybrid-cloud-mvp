variable "aws_region" {
  default = "eu-west-2"
}

variable "shared_vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "prod_vpc_cidr" {
  default = "10.20.0.0/16"
}

variable "dr_vpc_cidr" {
  default = "10.30.0.0/16"
}

variable "default_tags" {
  type = map(string)
  default = {
    Environment = "Hybrid-MVP"
    Owner       = "Student"
    CostCentre  = "Research"
  }
}

