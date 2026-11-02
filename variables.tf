variable "aws_endpoint" {
  type        = string
  description = "Endpoint that replaces every AWS service endpoint. Null everywhere except the local environment and the tests."
  default     = null
}

variable "region" {
  type        = string
  description = "AWS region. WAF with scope CLOUDFRONT and CloudFront certificates live in us-east-1."
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  description = "Tags added to every resource."
  default     = {}
}

variable "product" {
  type        = string
  description = "Name of the product; the prefix of every resource. Renamed by terraform-aws-scaffold."
  default     = "pluto-template"

  validation {
    condition     = can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", var.product)) && length(var.product) <= 24
    error_message = "The product is lowercase letters, digits and single hyphens, at most 24 characters."
  }
}

variable "environment" {
  type        = string
  description = "local, dev, hml or prd."

  validation {
    condition     = contains(["local", "dev", "hml", "prd"], var.environment)
    error_message = "The environment is local, dev, hml or prd."
  }
}

variable "nat_gateways" {
  type        = number
  description = "NAT gateways of the network: 0 on local, 1 in dev and hml, 2 in prd."
  default     = 1
}

variable "certificate_arn" {
  type        = string
  description = "ACM certificate of the load balancer (region of the stack). Null is refused unless allow_http_only."
  default     = null
}

variable "allow_http_only" {
  type        = bool
  description = "Serve the BFF over plain HTTP. For the local environment (the emulator) only."
  default     = false
}

variable "desired_count" {
  type        = number
  description = "Tasks of the BFF service. 0 on local: no image has been pushed to the emulator."
  default     = 1
}

variable "container_image_tag" {
  type        = string
  description = "Tag of the BFF image in the repository. Never latest; the release pipeline sets it."
  default     = "0.0.0"
}

variable "bff_environment" {
  type        = map(string)
  description = "Environment variables of the BFF container (the token settings, for one). Never put a secret here: secrets come from Secrets Manager."
  default     = {}
}

variable "secret_recovery_window_in_days" {
  type        = number
  description = "Recovery window of the BFF secret."
  default     = 7
}

variable "allow_immediate_delete" {
  type        = bool
  description = "Allow a recovery window of 0 days. For the local environment only."
  default     = false
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM certificate in us-east-1 for the web aliases. Null serves the default cloudfront.net certificate."
  default     = null
}

variable "web_aliases" {
  type        = list(string)
  description = "Domain names of the web distribution; they need acm_certificate_arn."
  default     = []
}
