terraform {
  required_version = ">= 1.2.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "< 5.0.0"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "devops-test-alv"
    workspaces {
      name = "prod-platform-auth"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

module "webapp_auth" {
  source = "../../../modules/webapp"
  bucket_name = "bucket1-prod"
  name = "auth"
  domain_name= "devopstest.g8w.co"
  zone = ""
}
