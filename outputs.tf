output "web_domain" {
  description = "Domain of the CloudFront distribution that serves the static web app."
  value       = module.web.domain_name
}

output "web_bucket_name" {
  description = "Bucket the static export is uploaded to."
  value       = module.web.bucket_name
}

output "web_distribution_id" {
  description = "CloudFront distribution id, for invalidations after a release."
  value       = module.web.distribution_id
}

output "bff_dns_name" {
  description = "DNS name of the load balancer in front of the BFF."
  value       = module.alb.dns_name
}

output "ecr_repository_url" {
  description = "Repository the BFF image is pushed to."
  value       = module.ecr.repository_url
}

output "secret_arn" {
  description = "ARN of the BFF secret. Set its value outside Terraform."
  value       = module.secrets.arn
}
