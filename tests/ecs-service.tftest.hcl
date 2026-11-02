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
    name_prefix  = "t-ecs-net"
    nat_gateways = 0
  }
}

run "alb" {
  command = apply

  module {
    source = "./modules/alb"
  }

  variables {
    name_prefix     = "t-ecs-alb"
    vpc_id          = run.network.vpc_id
    vpc_cidr        = run.network.vpc_cidr
    subnet_ids      = run.network.public_subnet_ids
    allow_http_only = true
  }
}

run "fargate_service" {
  command = apply

  module {
    source = "./modules/ecs-service"
  }

  variables {
    name_prefix           = "t-ecs"
    image                 = "000000000000.dkr.ecr.us-east-1.amazonaws.com/shop-bff:1.2.3"
    desired_count         = 0
    vpc_id                = run.network.vpc_id
    subnet_ids            = run.network.private_subnet_ids
    target_group_arn      = run.alb.target_group_arn
    alb_security_group_id = run.alb.security_group_id
  }

  assert {
    condition     = output.launch_type == "FARGATE" && output.assign_public_ip == false
    error_message = "The service must run on Fargate with no public IP."
  }

  assert {
    condition     = output.task_role_arn != output.execution_role_arn
    error_message = "The task and execution roles must be separate."
  }

  assert {
    condition     = output.log_retention_days == 30
    error_message = "Logs are kept 30 days by default."
  }

  assert {
    condition     = jsondecode(output.container_definition)[0].readonlyRootFilesystem == true && jsondecode(output.container_definition)[0].user == "10001" && jsondecode(output.container_definition)[0].mountPoints[0].containerPath == "/tmp"
    error_message = "The container needs a read-only root filesystem and a non-root user."
  }

  assert {
    condition     = output.desired_count == 0
    error_message = "desired_count is passed through."
  }

  assert {
    condition     = output.circuit_breaker.enable == true && output.circuit_breaker.rollback == true
    error_message = "The deployment circuit breaker must be on, with rollback."
  }
}

run "latest_is_refused" {
  command = plan

  module {
    source = "./modules/ecs-service"
  }

  variables {
    name_prefix           = "t-ecs-r1"
    image                 = "000000000000.dkr.ecr.us-east-1.amazonaws.com/shop-bff:latest"
    vpc_id                = run.network.vpc_id
    subnet_ids            = run.network.private_subnet_ids
    target_group_arn      = run.alb.target_group_arn
    alb_security_group_id = run.alb.security_group_id
  }

  expect_failures = [var.image]
}

run "no_tag_is_refused" {
  command = plan

  module {
    source = "./modules/ecs-service"
  }

  variables {
    name_prefix           = "t-ecs-r2"
    image                 = "000000000000.dkr.ecr.us-east-1.amazonaws.com/shop-bff"
    vpc_id                = run.network.vpc_id
    subnet_ids            = run.network.private_subnet_ids
    target_group_arn      = run.alb.target_group_arn
    alb_security_group_id = run.alb.security_group_id
  }

  expect_failures = [var.image]
}

run "root_user_spellings_are_refused" {
  command = plan

  module {
    source = "./modules/ecs-service"
  }

  variables {
    name_prefix           = "t-ecs-r4"
    image                 = "000000000000.dkr.ecr.us-east-1.amazonaws.com/shop-bff:1.2.3"
    user                  = "root:root"
    vpc_id                = run.network.vpc_id
    subnet_ids            = run.network.private_subnet_ids
    target_group_arn      = run.alb.target_group_arn
    alb_security_group_id = run.alb.security_group_id
  }

  expect_failures = [var.user]
}

run "uid_zero_with_a_group_is_refused" {
  command = plan

  module {
    source = "./modules/ecs-service"
  }

  variables {
    name_prefix           = "t-ecs-r5"
    image                 = "000000000000.dkr.ecr.us-east-1.amazonaws.com/shop-bff:1.2.3"
    user                  = "0:1000"
    vpc_id                = run.network.vpc_id
    subnet_ids            = run.network.private_subnet_ids
    target_group_arn      = run.alb.target_group_arn
    alb_security_group_id = run.alb.security_group_id
  }

  expect_failures = [var.user]
}

run "a_user_and_group_are_accepted" {
  command = plan

  module {
    source = "./modules/ecs-service"
  }

  variables {
    name_prefix           = "t-ecs-ok"
    image                 = "000000000000.dkr.ecr.us-east-1.amazonaws.com/shop-bff:1.2.3"
    user                  = "10001:10001"
    vpc_id                = run.network.vpc_id
    subnet_ids            = run.network.private_subnet_ids
    target_group_arn      = run.alb.target_group_arn
    alb_security_group_id = run.alb.security_group_id
  }

  assert {
    condition     = output.launch_type == "FARGATE"
    error_message = "A user and group such as 10001:10001 is accepted."
  }
}

run "root_user_is_refused" {
  command = plan

  module {
    source = "./modules/ecs-service"
  }

  variables {
    name_prefix           = "t-ecs-r3"
    image                 = "000000000000.dkr.ecr.us-east-1.amazonaws.com/shop-bff:1.2.3"
    user                  = "root"
    vpc_id                = run.network.vpc_id
    subnet_ids            = run.network.private_subnet_ids
    target_group_arn      = run.alb.target_group_arn
    alb_security_group_id = run.alb.security_group_id
  }

  expect_failures = [var.user]
}
