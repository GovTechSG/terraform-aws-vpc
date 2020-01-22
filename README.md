# terraform-aws-vpc

This is an opinionated Terraform Module for provisioning a VPC on AWS. It makes use of the community
provided (extensive) [module](https://github.com/terraform-aws-modules/terraform-aws-vpc) to
provision a VPC on AWS.

In particular, it does the following:

- Provisions (optional) public, private, database, intra and redshift subnets
- One NAT gateway per AZ
- Removes all default security group and ACL rules
- Provides sane ACL rules for network access

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| additional\_allowed\_cidr\_blocks | Additional 'safe' CIDR blocks for internal traffic | `list(string)` | `[]` | no |
| database\_subnets | List of CIDRs for database subnets | `list(string)` | `[]` | no |
| eip\_count | Number of EIP for the gateways. This should be eqaual to the number of AZs if you have any private subnets | `number` | `3` | no |
| elasticache\_subnets | List of CIDRs for Elasticache subnets | `list(string)` | `[]` | no |
| enable\_dynamodb\_endpoint | Should be true if you want to provision a DynamoDB endpoint to the VPC | `bool` | `false` | no |
| enable\_s3\_endpoint | Should be true if you want to provision an S3 endpoint to the VPC | `bool` | `false` | no |
| ephemeral\_from | Lower end of the port range for ephemeral traffic | `number` | `1024` | no |
| ephemeral\_to | Lower end of the port range for ephemeral traffic | `number` | `65535` | no |
| intra\_subnets | List of CIDRs for intra subnets | `list(string)` | `[]` | no |
| private\_subnets | List of CIDRs for private subnets | `list(string)` | `[]` | no |
| public\_subnets | List of CIDRs for public subnets | `list(string)` | `[]` | no |
| redshift\_subnets | List of CIDRs for Redshift subnets | `list(string)` | `[]` | no |
| tags | A map of tags to add to all resources | `map(string)` | <pre>{<br>  "Terraform": "true"<br>}<br></pre> | no |
| vpc\_cidr | CIDR for the VPC | `string` | n/a | yes |
| vpc\_name | Name of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| database\_acl\_id | ACL ID of the database subnets |
| elasticache\_route\_table\_ids | List of IDs of elasticache route tables |
| elasticache\_subnet\_group | ID of elasticache subnet group |
| elasticache\_subnet\_group\_name | Name of elasticache subnet group |
| elasticache\_subnets | List of IDs of elasticache subnets |
| elasticache\_subnets\_cidr\_blocks | List of cidr\_blocks of elasticache subnets |
| intra\_acl\_id | ACL ID of the intra subnets |
| intra\_subnets\_cidr\_blocks | List of cidr\_blocks of intra subnets |
| private\_acl\_id | ACL ID of the private subnets |
| private\_subnets\_cidr\_blocks | List of cidr\_blocks of private subnets |
| public\_acl\_id | ACL ID of the public subnets |
| public\_subnets\_cidr\_blocks | List of cidr\_blocks of public subnets |
| redshift\_route\_table\_ids | List of IDs of redshift route tables |
| redshift\_subnet\_group | ID of redshift subnet group |
| redshift\_subnets | List of IDs of redshift subnets |
| redshift\_subnets\_cidr\_blocks | List of cidr\_blocks of redshift subnets |
| vpc\_azs | The AZs in the region the VPC belongs to |
| vpc\_cidr\_block | The CIDR block of the VPC |
| vpc\_database\_subnet\_group | ID of database subnet group |
| vpc\_database\_subnets | List of IDs of database subnets |
| vpc\_database\_subnets\_cidr\_blocks | List of cidr\_blocks of database subnets |
| vpc\_id | The ID of the VPC |
| vpc\_intra\_subnets | 'Intra' subnets for the VPC |
| vpc\_nat\_eip\_ids | EIP for the NAT gateway in the VPC |
| vpc\_nat\_eip\_public | Public address for the EIP on the NAT Gateway |
| vpc\_private\_route\_table\_ids | List of IDs of private route tables |
| vpc\_private\_subnets | Private subnets for the VPC |
| vpc\_public\_route\_table\_ids | The IDs of the public route tables |
| vpc\_public\_subnets | Public subnets for the VPC |
| vpc\_region | The region the VPC belongs to |
