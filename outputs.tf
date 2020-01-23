output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_public_subnets" {
  description = "Public subnets for the VPC"
  value       = module.vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "vpc_private_subnets" {
  description = "Private subnets for the VPC"
  value       = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "vpc_intra_subnets" {
  description = "'Intra' subnets for the VPC"
  value       = module.vpc.intra_subnets
}

output "intra_subnets_cidr_blocks" {
  description = "List of cidr_blocks of intra subnets"
  value       = module.vpc.intra_subnets_cidr_blocks
}

output "vpc_database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "vpc_database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = module.vpc.database_subnets_cidr_blocks
}

output "vpc_database_subnet_group" {
  description = "ID of database subnet group"
  value       = module.vpc.database_subnet_group
}

output "vpc_public_route_table_ids" {
  description = "The IDs of the public route tables"
  value       = module.vpc.public_route_table_ids
}

output "vpc_private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.vpc.private_route_table_ids
}

output "vpc_region" {
  description = "The region the VPC belongs to"
  value       = data.aws_region.current.name
}

output "vpc_azs" {
  description = "The AZs in the region the VPC belongs to"
  value       = data.aws_availability_zones.available.names
}

output "vpc_nat_eip_ids" {
  description = "EIP for the NAT gateway in the VPC"
  value       = aws_eip.nat.*.id
}

output "vpc_nat_eip_public" {
  description = "Public address for the EIP on the NAT Gateway"
  value       = aws_eip.nat.*.public_ip
}

output "public_acl_id" {
  description = "ACL ID of the public subnets"
  value       = aws_network_acl.public.id
}

output "private_acl_id" {
  description = "ACL ID of the private subnets"
  value       = aws_network_acl.private.id
}

output "database_acl_id" {
  description = "ACL ID of the database subnets"
  value       = aws_network_acl.database.id
}

output "intra_acl_id" {
  description = "ACL ID of the intra subnets"
  value       = aws_network_acl.intra.id
}

output "redshift_route_table_ids" {
  description = "List of IDs of redshift route tables"
  value       = module.vpc.redshift_route_table_ids
}

output "redshift_subnet_group" {
  description = "ID of redshift subnet group"
  value       = module.vpc.redshift_subnet_group
}

output "redshift_subnets" {
  description = "List of IDs of redshift subnets"
  value       = module.vpc.redshift_subnets
}

output "redshift_subnets_cidr_blocks" {
  description = "List of cidr_blocks of redshift subnets"
  value       = module.vpc.redshift_subnets_cidr_blocks
}

output "elasticache_route_table_ids" {
  description = "List of IDs of elasticache route tables"
  value       = module.vpc.elasticache_route_table_ids
}

output "elasticache_subnet_group" {
  description = "ID of elasticache subnet group"
  value       = module.vpc.elasticache_subnet_group
}

output "elasticache_subnet_group_name" {
  description = "Name of elasticache subnet group"
  value       = module.vpc.elasticache_subnet_group_name
}

output "elasticache_subnets" {
  description = "List of IDs of elasticache subnets"
  value       = module.vpc.elasticache_subnets
}

output "elasticache_subnets_cidr_blocks" {
  description = "List of cidr_blocks of elasticache subnets"
  value       = module.vpc.elasticache_subnets_cidr_blocks
}
