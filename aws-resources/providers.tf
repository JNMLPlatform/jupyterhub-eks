terraform {
  required_version = ">= 0.12.0"

  backend "s3" {
    bucket = "terraform-billerxchange"
    key    = "terraform-state/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  version = "~> 3.0"
  region  = var.aws_region
}