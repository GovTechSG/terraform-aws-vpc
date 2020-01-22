variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
}

################################################
# Optional variables
################################################
variable "public_subnets" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
  default     = []
}

variable "database_subnets" {
  description = "List of CIDRs for database subnets"
  type        = list(string)
  default     = []
}

variable "intra_subnets" {
  description = "List of CIDRs for intra subnets"
  type        = list(string)
  default     = []
}

variable "redshift_subnets" {
  description = "List of CIDRs for Redshift subnets"
  type        = list(string)
  default     = []
}

variable "elasticache_subnets" {
  description = "List of CIDRs for Elasticache subnets"
  type        = list(string)
  default     = []
}

variable "eip_count" {
  description = "Number of EIP for the gateways. This should be eqaual to the number of AZs if you have any private subnets"
  default     = 3
}

variable "additional_allowed_cidr_blocks" {
  description = "Additional 'safe' CIDR blocks for internal traffic"
  type        = list(string)
  default     = []
}

variable "ephemeral_from" {
  description = "Lower end of the port range for ephemeral traffic"
  default     = 1024
}

variable "ephemeral_to" {
  description = "Lower end of the port range for ephemeral traffic"
  default     = 65535
}

variable "enable_s3_endpoint" {
  description = "Should be true if you want to provision an S3 endpoint to the VPC"
  default     = false
}

variable "enable_dynamodb_endpoint" {
  description = "Should be true if you want to provision a DynamoDB endpoint to the VPC"
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)

  default = {
    Terraform = "true"
  }
}
