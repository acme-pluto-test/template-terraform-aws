output "vpc_id" {
  description = "Id of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Ids of the two public subnets, for load balancers and NAT gateways."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Ids of the two private subnets, for the workloads."
  value       = aws_subnet.private[*].id
}

output "availability_zones" {
  description = "The availability zones of the subnets, public then private."
  value       = concat(aws_subnet.public[*].availability_zone, aws_subnet.private[*].availability_zone)
}

output "nat_gateway_ids" {
  description = "Ids of the NAT gateways; empty when nat_gateways is 0."
  value       = aws_nat_gateway.this[*].id
}

output "internet_gateway_id" {
  description = "Id of the internet gateway."
  value       = aws_internet_gateway.this.id
}

output "route_table_ids" {
  description = "Ids of the route tables: public first, then the two private ones."
  value       = concat([aws_route_table.public.id], aws_route_table.private[*].id)
}
