output "dns_name" {
  description = "DNS name of the load balancer."
  value       = aws_lb.this.dns_name
}

output "security_group_id" {
  description = "Security group of the load balancer; the targets accept traffic from it only."
  value       = aws_security_group.alb.id
}

output "target_group_arn" {
  description = "ARN of the target group the service registers in."
  value       = aws_lb_target_group.this.arn
}

output "http_default_action" {
  description = "What the port 80 listener does: redirect with a certificate, forward without one."
  value       = aws_lb_listener.http.default_action[0].type
}

output "https_listener_ssl_policy" {
  description = "TLS policy of the HTTPS listener, or null when there is none."
  value       = one(aws_lb_listener.https[*].ssl_policy)
}

output "drop_invalid_header_fields" {
  description = "Whether the load balancer drops invalid header fields."
  value       = aws_lb.this.drop_invalid_header_fields
}

output "https_default_action" {
  description = "What the HTTPS listener does: forward, or null when there is no HTTPS listener."
  value       = one(aws_lb_listener.https[*].default_action[0].type)
}

output "http_redirect" {
  description = "Where port 80 redirects, as PROTOCOL:PORT:STATUS, or null when it forwards."
  value       = one([for r in aws_lb_listener.http.default_action[0].redirect : "${r.protocol}:${r.port}:${r.status_code}"])
}
