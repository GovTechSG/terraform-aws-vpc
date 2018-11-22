# terraform-aws-vpc

This is an opinionated Terraform Module for provisioning a VPC on AWS. It makes use of the community
provided (extensive) [module](https://github.com/terraform-aws-modules/terraform-aws-vpc) to
provision a VPC on AWS.

In particular, it does the following:

- Provisions (optional) public, private, database and intra subnets
- One NAT gateway per AZ
- Removes all default security group and ACL rules
- Provides sane ACL rules for network access

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional_allowed_cidr_blocks | Additional 'safe' CIDR blocks for internal traffic | string | `<list>` | no |
| database_subnets | List of CIDRs for database subnets | string | `<list>` | no |
| eip_count | Number of EIP for the gateways. This should be eqaual to the number of AZs if you have any private subnets | string | `3` | no |
| elasticache_subnets | Lsit of CIDRs for Elasticache subnets | string | `<list>` | no |
| enable_dynamodb_endpoint | Should be true if you want to provision a DynamoDB endpoint to the VPC | string | `false` | no |
| enable_s3_endpoint | Should be true if you want to provision an S3 endpoint to the VPC | string | `false` | no |
| ephemeral_from | Lower end of the port range for ephemeral traffic | string | `1024` | no |
| ephemeral_to | Lower end of the port range for ephemeral traffic | string | `65535` | no |
| intra_subnets | List of CIDRs for intra subnets | string | `<list>` | no |
| private_subnets | List of CIDRs for private subnets | string | `<list>` | no |
| public_subnets | List of CIDRs for public subnets | string | `<list>` | no |
| redshift_subnets | Lsit of CIDRs for Redshift subnets | string | `<list>` | no |
| tags | A map of tags to add to all resources | string | `<map>` | no |
| vpc_cidr | CIDR for the VPC | string | - | yes |
| vpc_name | Name of the VPC | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| database_acl_id | ACL ID of the database subnets |
| elasticache_route_table_ids | List of IDs of elasticache route tables |
| elasticache_subnet_group | ID of elasticache subnet group |
| elasticache_subnet_group_name | Name of elasticache subnet group |
| elasticache_subnets | List of IDs of elasticache subnets |
| elasticache_subnets_cidr_blocks | List of cidr_blocks of elasticache subnets |
| intra_acl_id | ACL ID of the intra subnets |
| intra_subnets_cidr_blocks | List of cidr_blocks of intra subnets |
| private_acl_id | ACL ID of the private subnets |
| private_subnets_cidr_blocks | List of cidr_blocks of private subnets |
| public_acl_id | ACL ID of the public subnets |
| public_subnets_cidr_blocks | List of cidr_blocks of public subnets |
| redshift_route_table_ids | List of IDs of redshift route tables |
| redshift_subnet_group | ID of redshift subnet group |
| redshift_subnets | List of IDs of redshift subnets |
| redshift_subnets_cidr_blocks | List of cidr_blocks of redshift subnets |
| vpc_azs | The AZs in the region the VPC belongs to |
| vpc_cidr_block | The CIDR block of the VPC |
| vpc_database_subnet_group | ID of database subnet group |
| vpc_database_subnets | List of IDs of database subnets |
| vpc_database_subnets_cidr_blocks | List of cidr_blocks of database subnets |
| vpc_id | The ID of the VPC |
| vpc_intra_subnets | 'Intra' subnets for the VPC |
| vpc_nat_eip_ids | EIP for the NAT gateway in the VPC |
| vpc_nat_eip_public | Public address for the EIP on the NAT Gateway |
| vpc_private_route_table_ids | List of IDs of private route tables |
| vpc_private_subnets | Private subnets for the VPC |
| vpc_public_route_table_ids | The IDs of the public route tables |
| vpc_public_subnets | Public subnets for the VPC |
| vpc_region | The region the VPC belongs to |
