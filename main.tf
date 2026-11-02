# The root only composes modules: no resource is declared here (FR-INF-02). A new capability is a new module with its test.
locals {
  name_prefix = "${var.product}-${var.environment}"
}

module "network" {
  source = "./modules/network"

  name_prefix  = local.name_prefix
  nat_gateways = var.nat_gateways
}

module "ecr" {
  source = "./modules/ecr"

  name = "${local.name_prefix}-bff"
}

module "secrets" {
  source = "./modules/secrets"

  name                    = "${var.product}/${var.environment}/bff"
  recovery_window_in_days = var.secret_recovery_window_in_days
  allow_immediate_delete  = var.allow_immediate_delete
}

module "alb" {
  source = "./modules/alb"

  name_prefix     = local.name_prefix
  vpc_id          = module.network.vpc_id
  vpc_cidr        = module.network.vpc_cidr
  subnet_ids      = module.network.public_subnet_ids
  certificate_arn = var.certificate_arn
  allow_http_only = var.allow_http_only
}

module "bff" {
  source = "./modules/ecs-service"

  name_prefix           = "${local.name_prefix}-bff"
  image                 = "${module.ecr.repository_url}:${var.container_image_tag}"
  desired_count         = var.desired_count
  vpc_id                = module.network.vpc_id
  subnet_ids            = module.network.private_subnet_ids
  target_group_arn      = module.alb.target_group_arn
  alb_security_group_id = module.alb.security_group_id
  environment           = var.bff_environment
  secrets               = { BFF_SECRET = module.secrets.arn }
}

module "waf" {
  source = "./modules/waf"

  name_prefix = local.name_prefix
}

module "web" {
  source = "./modules/static-site"

  bucket_name         = "${local.name_prefix}-web"
  web_acl_arn         = module.waf.arn
  acm_certificate_arn = var.acm_certificate_arn
  aliases             = var.web_aliases
}
