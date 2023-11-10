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
      name = "dev-platform-info"
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

module "webapp_info" {
  source = "../../../modules/webapp"
  bucket_name = "bucket2-dev"
  name = "info"
  domain_name= "devopstest.dev.g8w.co"
  zone = "Z060497011SI50TIA0K9T"
}

output "cloudfront_arn_info"  {
  value = module.webapp_info.cloudfront_arn
}
