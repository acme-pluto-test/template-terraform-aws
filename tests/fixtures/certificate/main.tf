# Test fixture: a certificate for the HTTPS listener of the alb module. Floci issues it at once.
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "domain_name" {
  type        = string
  description = "Domain the certificate is requested for."
}

resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

output "arn" {
  description = "ARN of the certificate."
  value       = aws_acm_certificate.this.arn
}
