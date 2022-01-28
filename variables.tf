variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "us-west-1"
}
variable "environment" {
  description = "User selects environment"
  type = string
  default = "Deployment_Test"
}
variable "your_name" {
  description = "Your Name?"
  type = string
  default = "Joe"
}
variable "ssh_location" {
  type        = string
  default     = "172.89.66.78/32"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24"
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets"
  type        = list(string)
  default = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24",
    "10.0.14.0/24",
    "10.0.15.0/24",
    "10.0.16.0/24",
    "10.0.17.0/24",
    "10.0.18.0/24"
  ]
}
# variable "intra_subnet_cidr_blocks" {
#   description = "Available cidr blocks for database subnets"
#   type        = list(string)
#   default = [
#     "10.0.21.0/24",
#     "10.0.22.0/24",
#     "10.0.23.0/24",
#     "10.0.24.0/24",
#     "10.0.25.0/24",
#     "10.0.26.0/24",
#     "10.0.27.0/24",
#     "10.0.28.0/24"
#   ]
# }

# variable "database_subnet_cidr_blocks" {
#   description = "Available cidr blocks for database subnets"
#   type        = list(string)
#   default = [
#     "10.0.31.0/24",
#     "10.0.32.0/24",
#     "10.0.33.0/24",
#     "10.0.34.0/24",
#     "10.0.35.0/24",
#     "10.0.36.0/24",
#     "10.0.37.0/24",
#     "10.0.38.0/24"
#   ]
# }
variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 2
}

# variable "intra_subnet_count" {
#   description = "Number of private subnets"
#   type        = number
#   default     = 1
# }

# variable "database_subnet_count" {
#   description = "Number of database subnets"
#   type        = number
#   default     = 2
# }
