variable "name" {
  type        = string
  description = "Name of the repository, for example shop-bff."
}

variable "keep_images" {
  type        = number
  description = "How many images the lifecycle policy keeps."
  default     = 20

  validation {
    condition     = var.keep_images >= 1
    error_message = "Keep at least one image."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags added to every resource."
  default     = {}
}
