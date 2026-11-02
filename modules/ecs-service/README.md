# ecs-service

A Fargate service for the BFF: its own cluster, a task definition with a read-only root filesystem and a non-root user, separate execution and task roles, a log group with retention, tasks in private subnets with no public IP, only the load balancer allowed in, and the deployment circuit breaker with rollback.

`image` needs an explicit tag other than `latest`. Secrets are passed as Secrets Manager ARNs in `secrets`, never as values.
