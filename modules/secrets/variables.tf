variable "name" {
  type        = string
  description = "Name of the secret, for example shop/dev/bff."
}

variable "recovery_window_in_days" {
  type        = number
  description = "Days a deleted secret can be recovered. 0 deletes at once and needs allow_immediate_delete."
  default     = 7

  validation {
    condition     = var.recovery_window_in_days >= 7 || (var.recovery_window_in_days == 0 && var.allow_immediate_delete)
    error_message = "Use 7 days or more; 0 only with allow_immediate_delete (the local environment)."
  }

  validation {
    condition     = var.recovery_window_in_days <= 30
    error_message = "The recovery window is at most 30 days."
  }
}

variable "allow_immediate_delete" {
  type        = bool
  description = "Allow a recovery window of 0 days. For the local environment only."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags added to every resource."
  default     = {}
}
