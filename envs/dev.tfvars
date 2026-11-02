# The certificate_arn stays null until the environment has one: the plan is refused until then (fail closed).
environment                    = "dev"
nat_gateways                   = 1
allow_http_only                = false
certificate_arn                = null
desired_count                  = 2
container_image_tag            = "0.0.0"
secret_recovery_window_in_days = 7
allow_immediate_delete         = false
