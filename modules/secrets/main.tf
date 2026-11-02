resource "aws_kms_key" "this" {
  description         = "Encrypts the secret ${var.name}."
  enable_key_rotation = true

  tags = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${replace(var.name, "/", "-")}"
  target_key_id = aws_kms_key.this.key_id
}

# The module creates the container only. The value is set outside Terraform, so it never reaches the state.
resource "aws_secretsmanager_secret" "this" {
  name                    = var.name
  kms_key_id              = aws_kms_key.this.arn
  recovery_window_in_days = var.recovery_window_in_days

  tags = var.tags
}
