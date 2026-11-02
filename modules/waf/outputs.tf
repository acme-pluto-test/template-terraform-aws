output "arn" {
  description = "ARN of the web ACL, for the CloudFront distribution."
  value       = aws_wafv2_web_acl.this.arn
}

output "scope" {
  description = "Scope of the web ACL."
  value       = aws_wafv2_web_acl.this.scope
}

output "default_action" {
  description = "The default action: allow or block."
  value       = length(aws_wafv2_web_acl.this.default_action[0].allow) > 0 ? "allow" : "block"
}

output "rule_group_names" {
  description = "Names of the AWS managed rule groups attached."
  value       = [for r in aws_wafv2_web_acl.this.rule : r.statement[0].managed_rule_group_statement[0].name if length(r.statement[0].managed_rule_group_statement) > 0]
}

output "rate_limit" {
  description = "Requests per 5 minutes per address before the rate rule blocks."
  value       = one([for r in aws_wafv2_web_acl.this.rule : r.statement[0].rate_based_statement[0].limit if length(r.statement[0].rate_based_statement) > 0])
}
