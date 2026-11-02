# network

A VPC with two public and two private subnets in two availability zones, an internet gateway, route tables and, optionally, NAT gateways. The default security group is closed.

| Input | Meaning |
| --- | --- |
| `name_prefix` | prefix of every name |
| `nat_gateways` | 0 to 2; 0 on `local` (Floci), 1 in `dev`, 2 in `prd` |

Outputs: `vpc_id`, `public_subnet_ids`, `private_subnet_ids`, `nat_gateway_ids`.
