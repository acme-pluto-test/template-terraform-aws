# A run that swaps the module replaces the root provider block, so every test file configures its own.
# The emulator endpoint comes from AWS_ENDPOINT_URL, which the provider reads itself; tests run on Floci only.
provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true
}

run "edge_acl" {
  command = apply

  module {
    source = "./modules/waf"
  }

  variables {
    name_prefix = "t-waf"
  }

  assert {
    condition     = output.scope == "CLOUDFRONT"
    error_message = "The web ACL must have scope CLOUDFRONT."
  }

  assert {
    condition     = output.default_action == "allow"
    error_message = "The default action is allow."
  }

  assert {
    condition     = contains(output.rule_group_names, "AWSManagedRulesCommonRuleSet") && contains(output.rule_group_names, "AWSManagedRulesKnownBadInputsRuleSet")
    error_message = "Expected the common and known-bad-inputs managed rule groups."
  }

  assert {
    condition     = output.rate_limit == 2000
    error_message = "The rate rule is 2000 requests per 5 minutes."
  }
}
