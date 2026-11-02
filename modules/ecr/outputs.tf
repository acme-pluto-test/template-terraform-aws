output "repository_url" {
  description = "URL of the repository, without a tag."
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "ARN of the repository."
  value       = aws_ecr_repository.this.arn
}

output "scan_on_push" {
  description = "Whether images are scanned when pushed."
  value       = aws_ecr_repository.this.image_scanning_configuration[0].scan_on_push
}

output "tag_mutability" {
  description = "IMMUTABLE: a tag cannot be pushed twice."
  value       = aws_ecr_repository.this.image_tag_mutability
}

output "encryption_type" {
  description = "Encryption type of the repository."
  value       = aws_ecr_repository.this.encryption_configuration[0].encryption_type
}

output "lifecycle_policy" {
  description = "The lifecycle policy, as JSON."
  value       = aws_ecr_lifecycle_policy.this.policy
}
