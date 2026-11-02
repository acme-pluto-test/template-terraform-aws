# secrets

A Secrets Manager secret encrypted with its own customer managed key (rotation on). It creates the container only: set the value outside Terraform (`aws secretsmanager put-secret-value`) so it never reaches the state.

Outputs: `arn` only for the secret; the key facts the tests read.
