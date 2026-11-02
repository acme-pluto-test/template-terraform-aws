output "arn" {
  description = "ARN of the secret. The value is never an output."
  value       = aws_secretsmanager_secret.this.arn
}

output "kms_key_arn" {
  description = "ARN of the key that encrypts the secret."
  value       = aws_kms_key.this.arn
}

output "key_rotation_enabled" {
  description = "Whether the key rotates."
  value       = aws_kms_key.this.enable_key_rotation
}

output "recovery_window_in_days" {
  description = "The recovery window in days."
  value       = aws_secretsmanager_secret.this.recovery_window_in_days
}
