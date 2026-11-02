# waf

A web ACL with scope `CLOUDFRONT` (it lives in us-east-1): default allow, the AWS managed common and known-bad-inputs rule groups and a rate-based rule (2000 requests per 5 minutes per address by default). Attach `arn` to the CloudFront distribution of `static-site`.
