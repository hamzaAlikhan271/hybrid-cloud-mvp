# -------------------------------------------------------------------
# Hybrid MVP - Transit Gateway VPN (Static Routing, Dual Tunnels)
# -------------------------------------------------------------------

variable "onprem_public_ip" {
  description = "Public IP of the on-prem strongSwan host (no /32 mask)"
  type        = string
  default     = "154.208.43.147"
}

variable "onprem_cidr" {
  description = "CIDR range of on-prem LAN"
  type        = string
  default     = "192.168.100.0/24"
}

# -----------------------------
# 1. Customer Gateway (On-Prem)
# -----------------------------
resource "aws_customer_gateway" "onprem" {
  bgp_asn    = 65010
  ip_address = var.onprem_public_ip
  type       = "ipsec.1"

  tags = merge(
    var.default_tags,
    { Name = "cgw-onprem-mac" }
  )
}

# ----------------------------------
# 2. VPN Connection to Transit GW
# ----------------------------------
resource "aws_vpn_connection" "tgw_vpn" {
  transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  customer_gateway_id = aws_customer_gateway.onprem.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = merge(
    var.default_tags,
    { Name = "vpn-onprem-to-aws" }
  )
}

# ----------------------------------------------------
# 3. Static Route: Allow AWS to reach on-prem network
# ----------------------------------------------------
resource "aws_ec2_transit_gateway_route" "onprem_route" {
  destination_cidr_block         = var.onprem_cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
  transit_gateway_attachment_id  = aws_vpn_connection.tgw_vpn.transit_gateway_attachment_id
}
