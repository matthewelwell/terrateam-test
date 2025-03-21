terraform {
  required_version = ">=1.9.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.74.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      Project = "terrateam-test"
    }
  }
}
