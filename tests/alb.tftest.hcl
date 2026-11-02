# A run that swaps the module replaces the root provider block, so every test file configures its own.
# The emulator endpoint comes from AWS_ENDPOINT_URL, which the provider reads itself; tests run on Floci only.
provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true
}

run "network" {
  command = apply

  module {
    source = "./modules/network"
  }

  variables {
    name_prefix  = "t-alb-net"
    nat_gateways = 0
  }
}

run "certificate" {
  command = apply

  module {
    source = "./tests/fixtures/certificate"
  }

  variables {
    domain_name = "bff.example.test"
  }
}

run "https_with_a_certificate" {
  command = apply

  module {
    source = "./modules/alb"
  }

  variables {
    name_prefix     = "t-alb-s"
    vpc_id          = run.network.vpc_id
    vpc_cidr        = run.network.vpc_cidr
    subnet_ids      = run.network.public_subnet_ids
    certificate_arn = run.certificate.arn
  }

  assert {
    condition     = output.https_listener_ssl_policy == "ELBSecurityPolicy-TLS13-1-2-2021-06"
    error_message = "The HTTPS listener must use a TLS 1.3 policy."
  }

  assert {
    condition     = output.http_default_action == "redirect" && output.http_redirect == "HTTPS:443:HTTP_301"
    error_message = "Port 80 must redirect to HTTPS on 443 with a 301."
  }

  assert {
    condition     = output.https_default_action == "forward"
    error_message = "The HTTPS listener must forward to the target group."
  }

  assert {
    condition     = output.drop_invalid_header_fields == true
    error_message = "The load balancer must drop invalid header fields."
  }
}

run "plain_http_for_local" {
  command = apply

  module {
    source = "./modules/alb"
  }

  variables {
    name_prefix     = "t-alb-h"
    vpc_id          = run.network.vpc_id
    vpc_cidr        = run.network.vpc_cidr
    subnet_ids      = run.network.public_subnet_ids
    allow_http_only = true
  }

  assert {
    condition     = output.http_default_action == "forward" && output.https_listener_ssl_policy == null && output.http_redirect == null && output.https_default_action == null
    error_message = "Without a certificate port 80 forwards and there is no HTTPS listener."
  }
}

run "no_certificate_is_refused" {
  command = plan

  module {
    source = "./modules/alb"
  }

  variables {
    name_prefix = "t-alb-r"
    vpc_id      = run.network.vpc_id
    vpc_cidr    = run.network.vpc_cidr
    subnet_ids  = run.network.public_subnet_ids
  }

  expect_failures = [var.certificate_arn]
}
