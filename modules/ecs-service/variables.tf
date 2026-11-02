variable "name_prefix" {
  type        = string
  description = "Prefix of every resource name, for example shop-dev-bff."
}

variable "image" {
  type        = string
  description = "Container image with an explicit tag, for example 123456789012.dkr.ecr.us-east-1.amazonaws.com/shop-bff:1.4.2. The tag latest is refused."

  validation {
    condition     = can(regex(":[A-Za-z0-9_][A-Za-z0-9_.-]{0,127}$", var.image)) && !endswith(var.image, ":latest")
    error_message = "The image needs an explicit tag other than latest."
  }
}

variable "container_port" {
  type        = number
  description = "Port the container listens on."
  default     = 8080
}

variable "cpu" {
  type        = number
  description = "Fargate CPU units."
  default     = 256
}

variable "memory" {
  type        = number
  description = "Fargate memory in MiB."
  default     = 512
}

variable "desired_count" {
  type        = number
  description = "How many tasks run. 0 on local, where no image has been pushed."
  default     = 1
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnets of the tasks."
}

variable "target_group_arn" {
  type        = string
  description = "Target group of the load balancer the service registers in."
}

variable "alb_security_group_id" {
  type        = string
  description = "Security group of the load balancer; the only source the tasks accept."
}

variable "environment" {
  type        = map(string)
  description = "Environment variables of the container. Never put a secret here."
  default     = {}
}

variable "secrets" {
  type        = map(string)
  description = "Environment variable name to the ARN of the Secrets Manager secret that fills it."
  default     = {}
}

variable "user" {
  type        = string
  description = "User the container runs as (user or user:group); never root or uid 0."
  default     = "10001"

  validation {
    condition     = !can(regex("^(root|0)(:.*)?$", var.user))
    error_message = "The container must not run as root."
  }
}

variable "log_retention_days" {
  type        = number
  description = "Days the container logs are kept."
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "Tags added to every resource."
  default     = {}
}
