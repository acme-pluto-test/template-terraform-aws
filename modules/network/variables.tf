variable "name_prefix" {
  type        = string
  description = "Prefix of every resource name, for example shop-dev."
}

variable "cidr" {
  type        = string
  description = "CIDR block of the VPC; the four subnets are carved out of it."
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "Exactly two availability zones."
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Give exactly two availability zones."
  }
}

variable "nat_gateways" {
  type        = number
  description = "How many NAT gateways to create, at most one per availability zone. 0 leaves the private subnets without internet access."
  default     = 1

  validation {
    condition     = var.nat_gateways >= 0 && var.nat_gateways <= 2 && floor(var.nat_gateways) == var.nat_gateways
    error_message = "nat_gateways must be 0, 1 or 2: at most one NAT gateway per availability zone."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags added to every resource."
  default     = {}
}
