# ecr

A container repository: scan on push, immutable tags, encryption, and a lifecycle policy that keeps the last `keep_images` images (20).

Outputs: `repository_url`, `repository_arn`, plus the settings the tests read (`scan_on_push`, `tag_mutability`, `encryption_type`, `lifecycle_policy`).
