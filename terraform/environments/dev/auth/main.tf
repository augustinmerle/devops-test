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
      name = "dev-platform-auth"
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
  bucket_name = "bucket1-dev"
  name = "auth"
  domain_name= "devopstest.dev.g8w.co"
  zone = "Z060497011SI50TIA0K9T"
}
