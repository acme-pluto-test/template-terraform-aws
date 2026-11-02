# A run that swaps the module replaces the root provider block, so every test file configures its own.
# The emulator endpoint comes from AWS_ENDPOINT_URL, which the provider reads itself; tests run on Floci only.
provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true
}

run "secret_with_a_rotating_key" {
  command = apply

  module {
    source = "./modules/secrets"
  }

  variables {
    name = "t/secrets-${formatdate("YYYYMMDDhhmmss", timestamp())}" # a secret deleted with a 7 day window still holds its name
  }

  assert {
    condition     = output.key_rotation_enabled == true
    error_message = "The key must rotate."
  }

  assert {
    condition     = output.recovery_window_in_days == 7
    error_message = "The default recovery window is 7 days."
  }

  assert {
    condition     = startswith(output.arn, "arn:aws:secretsmanager:") && output.kms_key_arn != ""
    error_message = "Expected the ARN of the secret and of its key."
  }
}

run "local_may_delete_at_once" {
  command = apply

  module {
    source = "./modules/secrets"
  }

  variables {
    name                    = "t/secrets-local"
    recovery_window_in_days = 0
    allow_immediate_delete  = true
  }

  assert {
    condition     = output.recovery_window_in_days == 0
    error_message = "allow_immediate_delete permits a window of 0."
  }
}

run "short_windows_are_refused" {
  command = plan

  module {
    source = "./modules/secrets"
  }

  variables {
    name                    = "t/secrets-short"
    recovery_window_in_days = 3
  }

  expect_failures = [var.recovery_window_in_days]
}

run "zero_needs_the_flag" {
  command = plan

  module {
    source = "./modules/secrets"
  }

  variables {
    name                    = "t/secrets-zero"
    recovery_window_in_days = 0
  }

  expect_failures = [var.recovery_window_in_days]
}
