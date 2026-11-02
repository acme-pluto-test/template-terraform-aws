# terraform init -backend-config=envs/prd.backend.hcl (after: cp envs/s3-backend.tf.txt backend.tf)
bucket       = "pluto-template-tfstate-prd"
key          = "prd/terraform.tfstate"
region       = "us-east-1"
encrypt      = true
use_lockfile = true
