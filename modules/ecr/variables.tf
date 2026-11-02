variable "name" {
  type        = string
  description = "Name of the repository, for example shop-bff."
}

variable "force_delete" {
  type        = bool
  description = "Delete the repository even when it holds images. For the local environment only."
  default     = false
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
