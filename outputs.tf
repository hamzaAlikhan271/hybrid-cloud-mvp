output "shared_vpc_id" {
  value = module.vpc_shared.vpc_id
}

output "prod_vpc_id" {
  value = module.vpc_prod.vpc_id
}

output "dr_vpc_id" {
  value = module.vpc_dr.vpc_id
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.tgw.id
}

output "transit_gateway_route_table_id" {
  value = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}
