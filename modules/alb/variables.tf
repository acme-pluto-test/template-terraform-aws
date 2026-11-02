variable "name_prefix" {
  type        = string
  description = "Prefix of every resource name, for example shop-dev."
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block of the VPC; the only destination the load balancer may reach."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Public subnets of the load balancer (two or more)."

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "A load balancer needs subnets in at least two availability zones."
  }
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate of the HTTPS listener. Null only together with allow_http_only."
  default     = null

  validation {
    condition     = var.certificate_arn != null || var.allow_http_only
    error_message = "Give a certificate_arn, or set allow_http_only = true (the local environment only)."
  }
}

variable "allow_http_only" {
  type        = bool
  description = "Serve plain HTTP on port 80 with no certificate. For the local environment (the emulator) only."
  default     = false
}

variable "container_port" {
  type        = number
  description = "Port the targets listen on."
  default     = 8080
}

variable "health_check_path" {
  type        = string
  description = "Path the target group probes."
  default     = "/actuator/health/readiness"
}

variable "tags" {
  type        = map(string)
  description = "Tags added to every resource."
  default     = {}
}
