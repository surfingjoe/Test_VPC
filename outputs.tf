output "aws_region" {
  description = "AWS region"
  value       = data.aws_region.current.name
}

output "vpc_id" {
  description = "Output VPC ID"
  value       = module.vpc.vpc_id
}


output "Controller-sg_id" {
  description = "Security group IDs for Controller"
  value       = [aws_security_group.controller-ssh.id]
}

output "web-sg_id" {
  description = "Security group IDs for Web servers"
  value       = [aws_security_group.web-sg.id]
}

output "app-sg_id" {
  description = "Security group IDs for Web servers"
  value       = [aws_security_group.app-sg.id]
}

output "alb-sg_id" {
  description = "Security group IDs for Web servers"
  value       = [aws_security_group.alb-sg.id]
}


output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

# output "intra_subnet_ids" {
#   description = "Private subnet IDs"
#   value       = module.vpc.intra_subnets
# }

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

# output "database_subnet_ids" {
#   description = "Private subnet IDs"
#   value       = module.vpc.database_subnets
# }