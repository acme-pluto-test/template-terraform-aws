# alb

An internet-facing application load balancer for the BFF. With a certificate: HTTPS on 443 with a TLS 1.3 policy and port 80 redirecting to it. Without one the plan is refused unless `allow_http_only` is true (the local environment on Floci).

Outputs: `dns_name`, `security_group_id`, `target_group_arn`.
