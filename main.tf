terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.0"
  }
}

data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

resource "aws_eip" "nat" {
  count = var.eip_count

  vpc  = true
  tags = merge(var.tags, { Name = "${var.vpc_name} NAT Gateway" })
}

module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v2.23.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                 = data.aws_availability_zones.available.names
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  database_subnets    = var.database_subnets
  redshift_subnets    = var.redshift_subnets
  elasticache_subnets = var.elasticache_subnets

  # Intra subnet with no internet access: https://github.com/terraform-aws-modules/terraform-aws-vpc#private-versus-intra-subnets
  intra_subnets = var.intra_subnets

  # One gateway per AZ: https://github.com/terraform-aws-modules/terraform-aws-vpc#nat-gateway-scenarios
  enable_nat_gateway     = var.eip_count > 0 ? "true" : "false"
  single_nat_gateway     = false
  one_nat_gateway_per_az = var.eip_count > 0 ? "true" : "false"

  reuse_nat_ips       = true
  external_nat_ip_ids = aws_eip.nat.*.id

  enable_vpn_gateway   = false
  enable_dns_hostnames = true

  enable_s3_endpoint       = var.eip_count > 0 ? var.enable_s3_endpoint : "false"
  enable_dynamodb_endpoint = var.eip_count > 0 ? var.enable_dynamodb_endpoint : "false"

  tags = var.tags
}

# Remove all default rules from the default security group
resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id
  tags   = merge(var.tags, { Name = "${var.vpc_name} Default Security Group" })
}

# Remove all rules from the default network ACL. That means all subnets, by default,
# `DENY` for all incoming and outgoing traffic
resource "aws_default_network_acl" "default" {
  default_network_acl_id = module.vpc.default_network_acl_id

  tags = merge(var.tags, { Name = "${var.vpc_name} Default ACLs" })

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

locals {
  internal_cidrs = distinct(concat([var.vpc_cidr], var.additional_allowed_cidr_blocks))
}

###########################################################
# ACL Rules for "public" subnets
# See https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Appendix_NACLs.html
###########################################################
resource "aws_network_acl" "public" {
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  tags = merge(var.tags, { Name = "${var.vpc_name} Public ACLs" })
}

resource "aws_network_acl_rule" "public_outgoing" {
  network_acl_id = aws_network_acl.public.id

  rule_number = "100"
  egress      = true
  protocol    = "all"
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_incoming_internal" {
  count          = length(local.internal_cidrs)
  network_acl_id = aws_network_acl.public.id

  rule_number = 100 + count.index
  egress      = false
  protocol    = "all"
  rule_action = "allow"
  cidr_block  = local.internal_cidrs[count.index]
}

resource "aws_network_acl_rule" "public_incoming_http" {
  network_acl_id = aws_network_acl.public.id

  rule_number = "200"
  egress      = false
  protocol    = "tcp"
  rule_action = "allow"
  from_port   = 80
  to_port     = 80
  cidr_block  = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_incoming_https" {
  network_acl_id = aws_network_acl.public.id

  rule_number = "201"
  egress      = false
  protocol    = "tcp"
  rule_action = "allow"
  from_port   = 443
  to_port     = 443
  cidr_block  = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_incoming_ephemeral" {
  network_acl_id = aws_network_acl.public.id

  rule_number = "202"
  egress      = false
  protocol    = "tcp"
  rule_action = "allow"
  from_port   = var.ephemeral_from
  to_port     = var.ephemeral_to
  cidr_block  = "0.0.0.0/0"
}

###########################################################
# ACL Rules for "private" submets
###########################################################
resource "aws_network_acl" "private" {
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = merge(var.tags, { Name = "${var.vpc_name} Private ACLs" })
}

resource "aws_network_acl_rule" "private_outgoing" {
  network_acl_id = aws_network_acl.private.id

  rule_number = "100"
  egress      = true
  protocol    = "all"
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_incoming_internal" {
  count          = length(local.internal_cidrs)
  network_acl_id = aws_network_acl.private.id

  rule_number = 200 + count.index
  egress      = false
  protocol    = "all"
  rule_action = "allow"
  cidr_block  = local.internal_cidrs[count.index]
}

resource "aws_network_acl_rule" "private_incoming_ephemeral" {
  network_acl_id = aws_network_acl.private.id

  rule_number = "101"
  egress      = false
  protocol    = "tcp"
  rule_action = "allow"
  from_port   = var.ephemeral_from
  to_port     = var.ephemeral_to
  cidr_block  = "0.0.0.0/0"
}

###########################################################
# ACL Rules for "database" submets
###########################################################
resource "aws_network_acl" "database" {
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.database_subnets

  tags = merge(var.tags, { Name = "${var.vpc_name} Database ACLs" })
}

resource "aws_network_acl_rule" "database_incoming_internal" {
  count          = length(local.internal_cidrs)
  network_acl_id = aws_network_acl.database.id

  rule_number = 200 + count.index
  egress      = false
  protocol    = "all"
  rule_action = "allow"
  cidr_block  = local.internal_cidrs[count.index]
}

resource "aws_network_acl_rule" "database_outgoing_internal" {
  count          = length(local.internal_cidrs)
  network_acl_id = aws_network_acl.database.id

  rule_number = 200 + count.index
  egress      = true
  protocol    = "all"
  rule_action = "allow"
  cidr_block  = local.internal_cidrs[count.index]
}

###########################################################
# ACL Rules for "intra" submets
###########################################################
resource "aws_network_acl" "intra" {
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.intra_subnets

  tags = merge(var.tags, { Name = "${var.vpc_name} Intra ACLs" })
}

resource "aws_network_acl_rule" "intra_incoming_internal" {
  count          = length(local.internal_cidrs)
  network_acl_id = aws_network_acl.intra.id

  rule_number = 200 + count.index
  egress      = false
  protocol    = "all"
  rule_action = "allow"
  cidr_block  = local.internal_cidrs[count.index]
}

resource "aws_network_acl_rule" "intra_outgoing_internal" {
  count          = length(local.internal_cidrs)
  network_acl_id = aws_network_acl.intra.id

  rule_number = 200 + count.index
  egress      = true
  protocol    = "all"
  rule_action = "allow"
  cidr_block  = local.internal_cidrs[count.index]
}

###########################################################
# ACL Rules for "elasticache" submets
###########################################################
resource "aws_network_acl" "elasticache" {
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.elasticache_subnets

  tags = merge(var.tags, { Name = "${var.vpc_name} ElastiCache ACLs" })
}

resource "aws_network_acl_rule" "elasticache_incoming_internal" {
  count          = length(local.internal_cidrs)
  network_acl_id = aws_network_acl.elasticache.id

  rule_number = 200 + count.index
  egress      = false
  protocol    = "all"
  rule_action = "allow"
  cidr_block  = local.internal_cidrs[count.index]
}

resource "aws_network_acl_rule" "elasticache_outgoing_internal" {
  count          = length(local.internal_cidrs)
  network_acl_id = aws_network_acl.elasticache.id

  rule_number = 200 + count.index
  egress      = true
  protocol    = "all"
  rule_action = "allow"
  cidr_block  = local.internal_cidrs[count.index]
}

###########################################################
# ACL Rules for "redshift" submets
###########################################################
resource "aws_network_acl" "redshift" {
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.redshift_subnets

  tags = merge(var.tags, { Name = "${var.vpc_name} RedShift ACLs" })
}

resource "aws_network_acl_rule" "redshift_incoming_internal" {
  count          = length(local.internal_cidrs)
  network_acl_id = aws_network_acl.redshift.id

  rule_number = 200 + count.index
  egress      = false
  protocol    = "all"
  rule_action = "allow"
  cidr_block  = local.internal_cidrs[count.index]
}

resource "aws_network_acl_rule" "redshift_outgoing_internal" {
  count          = length(local.internal_cidrs)
  network_acl_id = aws_network_acl.redshift.id

  rule_number = 200 + count.index
  egress      = true
  protocol    = "all"
  rule_action = "allow"
  cidr_block  = local.internal_cidrs[count.index]
}
