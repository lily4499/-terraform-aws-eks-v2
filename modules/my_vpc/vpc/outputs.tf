output "availability_zones" {
  value = data.aws_availability_zones.available_zones.names
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.eks_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = [aws_subnet.pub_one.id, aws_subnet.pub_two.id]
}

output "private_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = [aws_subnet.priv_one.id, aws_subnet.priv_two.id]
}

#output "public_subnet_ids" {
#  value = aws_subnet.public_subnets[*].id
#}

#output "private_subnet_ids" {
#  value = aws_subnet.private_subnets[*].id
#}


