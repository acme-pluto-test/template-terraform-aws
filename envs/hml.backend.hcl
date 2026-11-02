# terraform init -backend-config=envs/hml.backend.hcl (after: cp envs/s3-backend.tf.txt backend.tf)
bucket       = "pluto-template-tfstate-hml"
key          = "hml/terraform.tfstate"
region       = "us-east-1"
encrypt      = true
use_lockfile = true
