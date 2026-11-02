variable "name_prefix" {
  type        = string
  description = "Prefix of the web ACL name, for example shop-dev."
}

variable "rate_limit" {
  type        = number
  description = "Requests per 5 minutes per address before the rate rule blocks."
  default     = 2000

  validation {
    condition     = var.rate_limit >= 100
    error_message = "The rate limit is at least 100."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags added to every resource."
  default     = {}
}
