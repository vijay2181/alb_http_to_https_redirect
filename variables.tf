# General Variables

variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

#key_pair name

variable "key_name" {
  description = "ec2 keypair name"
  type        = string
  default     = "aws_key" #give keypair name in aws 
}

#username

variable "username" {
  description = "aws username"
  type        = string
  default     = "ec2-user" #give user-name
}

#profile

variable "profile" {
  description = "aws profile name"
  type        = string
  default     = "test" #give profile name
}

#dns record for alb 

variable "record" {
  description = "subdomain record for certificate"
  type        = string
  default     = "app.example.com" #give subdomain on which you needs certificate
}

# public_dns_name = "example.com"
# dns_hostname    = "app"

variable "public_dns_name" {
  description = "subdomain record for certificate"
  type        = string
  default     = "example.com" #give subdomain on which you needs certificate
}

variable "dns_hostname" {
  description = "subdomain record for certificate"
  type        = string
  default     = "app" #give subdomain on which you needs certificate
}
