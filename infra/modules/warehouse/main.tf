# Warehouse module — provisions the schemas/datasets RiskLens needs
# (bronze, silver, gold) for a single environment.
#
# TODO (Week 2 / FR-7): implement using the snowflake or google
# providers depending on WAREHOUSE_TYPE. Keep this module provider-agnostic
# at the interface level (variables.tf) so environments/{dev,staging,prod}
# don't need to know which warehouse is behind it.

variable "environment" {
  description = "dev | staging | prod"
  type        = string
}

variable "warehouse_type" {
  description = "snowflake | bigquery"
  type        = string
}

# TODO: resource blocks for schemas/datasets:
#   - risklens_<env>_bronze
#   - risklens_<env>_silver
#   - risklens_<env>_gold

output "schema_names" {
  value = {
    bronze = "risklens_${var.environment}_bronze"
    silver = "risklens_${var.environment}_silver"
    gold   = "risklens_${var.environment}_gold"
  }
}
