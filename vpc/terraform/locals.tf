# Define Local Values in Terraform
locals {
  owners = "terraform"
  environment = var.environment
  name = "${var.project_name}-${var.environment}"
  common_tags = {
    owners = local.owners
    environment = local.environment
  }
}