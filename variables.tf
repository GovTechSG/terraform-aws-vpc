variable "vpc_name" {
  description = "Name of the VPC"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
}

################################################
# Optional variables
################################################
variable "public_subnets" {
  description = "List of CIDRs for public subnets"
  default     = []
}

variable "private_subnets" {
  description = "List of CIDRs for private subnets"
  default     = []
}

variable "database_subnets" {
  description = "List of CIDRs for database subnets"
  default     = []
}

variable "intra_subnets" {
  description = "List of CIDRs for intra subnets"
  default     = []
}

variable "eip_count" {
  description = "Number of EIP for the gateways. This should be eqaual to the number of AZs if you have any private subnets"
  default     = 3
}

variable "additional_allowed_cidr_blocks" {
  description = "Additional 'safe' CIDR blocks for internal traffic"
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

  default = {
    Terraform = "true"
  }
}
