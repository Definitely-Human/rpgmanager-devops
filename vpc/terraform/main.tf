# Terraform Block
terraform {
  required_version = "~> 1.8.2"
  required_providers {
    aws = {
       source = "hashicorp/aws"
       version = "~> 5.25"
    }
  }

  backend "s3" {
    bucket = "rpg-project-tfstate"
    key    = "dev/vpc/terraform.tfstate"
    region = "eu-central-1"

    dynamodb_table = "rpg-terraform-vpc"
  }

}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
}
/*
Note-1:  AWS Credentials Profile (profile = "default") configured on your local desktop terminal
$HOME/.aws/credentials
*/