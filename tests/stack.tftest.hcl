# The root module composed and applied on Floci with the values of envs/local.tfvars (the endpoint comes from TF_VAR_aws_endpoint).

run "local_environment" {
  command = apply

  variables {
    product                        = "t-stack"
    environment                    = "local"
    nat_gateways                   = 0
    allow_http_only                = true
    desired_count                  = 0
    secret_recovery_window_in_days = 0
    allow_immediate_delete         = true
  }

  assert {
    condition     = output.web_domain != "" && output.bff_dns_name != ""
    error_message = "Expected the domain of the web distribution and the DNS name of the load balancer."
  }

  assert {
    condition     = endswith(output.ecr_repository_url, "/t-stack-local-bff")
    error_message = "Expected the BFF repository."
  }

  assert {
    condition     = startswith(output.secret_arn, "arn:aws:secretsmanager:")
    error_message = "Expected the ARN of the BFF secret."
  }

  assert {
    condition     = module.bff.desired_count == 0 && module.bff.launch_type == "FARGATE"
    error_message = "The service runs on Fargate with no task on the emulator."
  }

  assert {
    condition     = length(module.network.nat_gateway_ids) == 0 && length(module.network.private_subnet_ids) == 2
    error_message = "The local network has two private subnets and no NAT gateway."
  }

  assert {
    condition     = module.web.public_access_blocked == true && module.web.viewer_protocol_policy == "redirect-to-https"
    error_message = "The static site is private and redirects to HTTPS."
  }

  assert {
    condition     = module.alb.http_default_action == "forward" && module.secrets.recovery_window_in_days == 0
    error_message = "The local load balancer forwards plain HTTP and the secret may be deleted at once."
  }
}
