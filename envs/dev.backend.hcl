# terraform init -backend-config=envs/dev.backend.hcl (after: cp envs/s3-backend.tf.txt backend.tf)
bucket       = "pluto-template-tfstate-dev"
key          = "dev/terraform.tfstate"
region       = "us-east-1"
encrypt      = true
use_lockfile = true
