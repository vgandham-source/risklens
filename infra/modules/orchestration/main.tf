# Orchestration module — provisions whatever the chosen orchestrator needs
# beyond what docker-compose handles locally (e.g., a managed Airflow/Dagster
# environment, IAM roles/service accounts, connection secrets).
#
# TODO (Week 2 / FR-7): implement based on your chosen orchestrator and
# whether it's self-hosted (via the docker-compose stack, likely little to
# no Terraform needed beyond secrets) or a managed service.

variable "environment" {
  description = "dev | staging | prod"
  type        = string
}
