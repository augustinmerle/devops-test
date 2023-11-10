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
      name = "dev-platform-customers"
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

module "webapp_customers" {
  source = "../../../modules/webapp"
  bucket_name = "bucket3-dev"
  name = "customers"
  domain_name= "devopstest.dev.g8w.co"
  zone = "Z060497011SI50TIA0K9T"
}

output "cloudfront_customers_id" {
  value = module.webapp_customers.cloudfront_id
}
