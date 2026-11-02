# pluto-template (infrastructure)

The starting point of every `<product>-infra` repository: one Terraform root module that composes the platform modules, one variables file per environment, and tests that apply every module on Floci.

```
docker compose up -d --wait                 # Floci 2.3.0 on :4566
export AWS_ENDPOINT_URL=http://localhost:4566 TF_VAR_aws_endpoint=http://localhost:4566 AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test
terraform init -input=false
terraform fmt -check -recursive && terraform validate
terraform test                              # a test file per module, plus stack
terraform apply -var-file=envs/local.tfvars # the local environment
```

| Path | What it holds |
| --- | --- |
| `main.tf` | the composition: modules only, no `resource` block |
| `modules/` | `network`, `ecr`, `alb`, `ecs-service`, `static-site`, `waf`, `secrets` (each with a README) |
| `envs/<env>.tfvars` | the values of `local`, `dev`, `hml`, `prd`; only `local` sets `aws_endpoint` |
| `envs/<env>.backend.hcl` | remote state for `dev`, `hml`, `prd`: `cp envs/s3-backend.tf.txt backend.tf`, then `terraform init -backend-config=envs/<env>.backend.hcl` |
| `tests/` | one `*.tftest.hcl` per module and `stack`, applied on Floci |

Rules: a capability the modules lack is a new module with its test, never a `resource` in the root (an ADR and approval otherwise). Nothing outside `envs/local.tfvars`, the tests and the compose file may know Floci. Rename the placeholder with the `terraform-aws-scaffold` skill; the conventions are in the `terraform-aws-*` skills of the catalog.

On Floci the BFF service runs with `desired_count = 0`: push an image to `ecr_repository_url` first (`docker login` with any password, then `docker push`) and raise the count.

Security of the emulator: the compose file publishes Floci on `127.0.0.1` only. Floci takes no credentials and, with the Docker socket mounted, can start containers on the host, so never publish it on another interface or run it on a shared machine.
