# A run that swaps the module replaces the root provider block, so every test file configures its own.
# The emulator endpoint comes from AWS_ENDPOINT_URL, which the provider reads itself; tests run on Floci only.
provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true
}

run "web_acl" {
  command = apply

  module {
    source = "./modules/waf"
  }

  variables {
    name_prefix = "t-site"
  }
}

run "site" {
  command = apply

  module {
    source = "./modules/static-site"
  }

  variables {
    bucket_name = "t-static-site"
    web_acl_arn = run.web_acl.arn
  }

  assert {
    condition     = output.public_access_blocked == true
    error_message = "All four S3 public access blocks must be on."
  }

  assert {
    condition     = output.versioning_status == "Enabled" && output.encryption_algorithm == "aws:kms"
    error_message = "The bucket must be versioned and encrypted."
  }

  assert {
    condition     = output.distribution_origin_access_control_id == output.origin_access_control_id
    error_message = "The origin must be read through origin access control."
  }

  assert {
    condition     = output.viewer_protocol_policy == "redirect-to-https" && output.default_root_object == "index.html"
    error_message = "Redirect viewers to HTTPS and serve index.html at the root."
  }

  assert {
    condition     = output.error_responses["403"] == "404 /404.html" && output.error_responses["404"] == "404 /404.html"
    error_message = "403 and 404 from the origin must answer 404 with /404.html."
  }

  assert {
    condition     = output.security_headers.hsts == 31536000 && output.security_headers.nosniff == true && output.security_headers.frame_options == "DENY"
    error_message = "The response headers policy needs HSTS, nosniff and frame denial."
  }
}

run "aliases_need_a_certificate" {
  command = plan

  module {
    source = "./modules/static-site"
  }

  variables {
    bucket_name = "t-static-site-aliases"
    aliases     = ["www.example.test"]
  }

  expect_failures = [var.aliases]
}
