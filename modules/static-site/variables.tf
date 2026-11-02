variable "bucket_name" {
  type        = string
  description = "Name of the private bucket that holds the static export."
}

variable "web_acl_arn" {
  type        = string
  description = "ARN of the web ACL (waf module) attached to the distribution, or null."
  default     = null
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM certificate in us-east-1 for the aliases. Null serves the default cloudfront.net certificate."
  default     = null
}

variable "aliases" {
  type        = list(string)
  description = "Domain names of the distribution; they need acm_certificate_arn."
  default     = []

  validation {
    condition     = length(var.aliases) == 0 || var.acm_certificate_arn != null
    error_message = "Aliases need an acm_certificate_arn."
  }
}

variable "content_security_policy" {
  type        = string
  description = "Content-Security-Policy header value, or null to send none."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags added to every resource."
  default     = {}
}

variable "force_destroy" {
  type        = bool
  description = "Delete the bucket even when it holds objects. For the local environment only."
  default     = false
}
