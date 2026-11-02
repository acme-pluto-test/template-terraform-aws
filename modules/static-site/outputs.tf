output "domain_name" {
  description = "Domain name of the CloudFront distribution."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "distribution_id" {
  description = "Id of the CloudFront distribution, for invalidations."
  value       = aws_cloudfront_distribution.site.id
}

output "bucket_name" {
  description = "Name of the private bucket the static export is uploaded to."
  value       = aws_s3_bucket.site.bucket
}

output "public_access_blocked" {
  description = "True when all four S3 public access blocks are on."
  value = alltrue([
    aws_s3_bucket_public_access_block.site.block_public_acls,
    aws_s3_bucket_public_access_block.site.block_public_policy,
    aws_s3_bucket_public_access_block.site.ignore_public_acls,
    aws_s3_bucket_public_access_block.site.restrict_public_buckets,
  ])
}

output "versioning_status" {
  description = "Versioning status of the bucket."
  value       = aws_s3_bucket_versioning.site.versioning_configuration[0].status
}

output "encryption_algorithm" {
  description = "Server-side encryption algorithm of the bucket."
  value       = one(aws_s3_bucket_server_side_encryption_configuration.site.rule[*].apply_server_side_encryption_by_default[0].sse_algorithm)
}

output "viewer_protocol_policy" {
  description = "What the distribution does with plain HTTP requests."
  value       = aws_cloudfront_distribution.site.default_cache_behavior[0].viewer_protocol_policy
}

output "default_root_object" {
  description = "Object served for the root path."
  value       = aws_cloudfront_distribution.site.default_root_object
}

output "error_responses" {
  description = "Map of origin error code to the status and page the viewer gets."
  value       = { for r in aws_cloudfront_distribution.site.custom_error_response : tostring(r.error_code) => "${r.response_code} ${r.response_page_path}" }
}

output "origin_access_control_id" {
  description = "Id of the origin access control the origin uses."
  value       = aws_cloudfront_origin_access_control.site.id
}

output "distribution_origin_access_control_id" {
  description = "Origin access control id as set on the distribution origin."
  value       = one([for o in aws_cloudfront_distribution.site.origin : o.origin_access_control_id])
}

output "security_headers" {
  description = "The security headers the response headers policy sets."
  value = {
    hsts          = aws_cloudfront_response_headers_policy.security.security_headers_config[0].strict_transport_security[0].access_control_max_age_sec
    nosniff       = aws_cloudfront_response_headers_policy.security.security_headers_config[0].content_type_options[0].override
    frame_options = aws_cloudfront_response_headers_policy.security.security_headers_config[0].frame_options[0].frame_option
  }
}
