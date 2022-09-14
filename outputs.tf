output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = aws_subnet.vpc-dev-private-subnet-1.id
}