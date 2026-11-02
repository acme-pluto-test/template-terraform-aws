# A run that swaps the module replaces the root provider block, so every test file configures its own.
# The emulator endpoint comes from AWS_ENDPOINT_URL, which the provider reads itself; tests run on Floci only.
provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true
}

run "secure_repository" {
  command = apply

  module {
    source = "./modules/ecr"
  }

  variables {
    name = "t-ecr"
  }

  assert {
    condition     = output.scan_on_push == true
    error_message = "Images must be scanned on push."
  }

  assert {
    condition     = output.tag_mutability == "IMMUTABLE"
    error_message = "Tags must be immutable."
  }

  assert {
    condition     = output.encryption_type == "AES256"
    error_message = "The repository must be encrypted."
  }

  assert {
    condition     = jsondecode(output.lifecycle_policy).rules[0].selection.countNumber == 20
    error_message = "The lifecycle policy must keep the last 20 images."
  }

  assert {
    condition     = endswith(output.repository_url, "/t-ecr")
    error_message = "The repository URL must end with the repository name."
  }
}
