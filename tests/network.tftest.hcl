# A run that swaps the module replaces the root provider block, so every test file configures its own.
# The emulator endpoint comes from AWS_ENDPOINT_URL, which the provider reads itself; tests run on Floci only.
provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true
}

run "one_nat_gateway" {
  command = apply

  module {
    source = "./modules/network"
  }

  variables {
    name_prefix  = "t-net1"
    nat_gateways = 1
  }

  assert {
    condition     = length(output.public_subnet_ids) == 2 && length(output.private_subnet_ids) == 2
    error_message = "Expected two public and two private subnets."
  }

  assert {
    condition     = length(distinct(output.availability_zones)) == 2
    error_message = "The subnets must span two availability zones."
  }

  assert {
    condition     = length(output.nat_gateway_ids) == 1
    error_message = "Expected one NAT gateway."
  }

  assert {
    condition     = output.vpc_id != "" && output.internet_gateway_id != "" && length(output.route_table_ids) == 3
    error_message = "Expected a VPC, an internet gateway and three route tables."
  }
}

run "no_nat_gateway" {
  command = apply

  module {
    source = "./modules/network"
  }

  variables {
    name_prefix  = "t-net0"
    nat_gateways = 0
  }

  assert {
    condition     = length(output.nat_gateway_ids) == 0
    error_message = "nat_gateways = 0 must create no NAT gateway."
  }
}

run "three_nat_gateways_are_refused" {
  command = plan

  module {
    source = "./modules/network"
  }

  variables {
    name_prefix  = "t-net3"
    nat_gateways = 3
  }

  expect_failures = [var.nat_gateways]
}
