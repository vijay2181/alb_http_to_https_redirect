####################################
## Network Public Only - Variables #
####################################

# AWS AZ #1
variable "aws_az_1" {
  type        = string
  description = "AWS AZ"
  default     = "us-west-2a"
}

# AWS AZ #2
variable "aws_az_2" {
  type        = string
  description = "AWS AZ"
  default     = "us-west-2b"
}

# AWS AZ #3
variable "aws_az_3" {
  type        = string
  description = "AWS AZ"
  default     = "us-west-2c"
}

# VPC
variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  default     = "10.1.64.0/18"
}

# Subnet #1
variable "public_subnet_cidr_1" {
  type        = string
  description = "CIDR for the public subnet"
  default     = "10.1.65.0/24"
}

# Subnet #2
variable "public_subnet_cidr_2" {
  type        = string
  description = "CIDR for the public subnet"
  default     = "10.1.66.0/24"
}

# Subnet #3
variable "public_subnet_cidr_3" {
  type        = string
  description = "CIDR for the public subnet"
  default     = "10.1.67.0/24"
}
