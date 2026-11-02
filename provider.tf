# The only place that knows an endpoint can be overridden. The variable is null everywhere except envs/local.tfvars and the tests.
locals {
  emulated = var.aws_endpoint != null
}

provider "aws" {
  region                      = var.region
  skip_credentials_validation = local.emulated
  skip_requesting_account_id  = local.emulated
  skip_metadata_api_check     = local.emulated
  s3_use_path_style           = local.emulated

  endpoints {
    cloudfront     = var.aws_endpoint
    ec2            = var.aws_endpoint
    ecr            = var.aws_endpoint
    ecs            = var.aws_endpoint
    elbv2          = var.aws_endpoint
    iam            = var.aws_endpoint
    kms            = var.aws_endpoint
    logs           = var.aws_endpoint
    s3             = var.aws_endpoint
    secretsmanager = var.aws_endpoint
    sts            = var.aws_endpoint
    wafv2          = var.aws_endpoint
  }

  default_tags {
    tags = merge(var.tags, { Product = var.product, Environment = var.environment })
  }
}
