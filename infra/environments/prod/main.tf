terraform {
  required_version = ">= 1.7"
  required_providers {
    # TODO: uncomment/add the provider matching your WAREHOUSE_TYPE
    # snowflake = { source = "Snowflake-Labs/snowflake" }
    # google    = { source = "hashicorp/google" }
  }

  # TODO: configure a remote backend per environment before this is
  # anything more than a local prototype (e.g., GCS or S3 backend with
  # a distinct state key per environment).
}

module "warehouse" {
  source         = "../../modules/warehouse"
  environment    = "prod"
  warehouse_type = var.warehouse_type
}

module "orchestration" {
  source      = "../../modules/orchestration"
  environment = "prod"
}
