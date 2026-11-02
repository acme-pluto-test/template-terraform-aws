# static-site

A private S3 bucket (public access blocked, versioned, encrypted) read by a CloudFront distribution through origin access control: HTTPS only, `index.html` as the root object, 403 and 404 answered with `/404.html` and status 404, and a response headers policy with HSTS, `nosniff` and frame denial (plus a CSP when `content_security_policy` is set).

Upload the static export with `aws s3 sync out/ s3://<bucket_name>`; cache headers are in the `react-static-export` skill. Pass `web_acl_arn` from the `waf` module to attach the web ACL.
