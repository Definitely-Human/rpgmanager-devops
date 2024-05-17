data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "rpg-project-tfstate"
    key    = "dev/vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}