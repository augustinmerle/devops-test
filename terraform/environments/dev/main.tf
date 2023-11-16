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
      name = "${var.app_environment}-platform"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "webapp_auth" {
  source = "./../../modules/webapp"
  name = "auth"
  bucket_name = "bucket1-${var.app_environment}"
  domain_name= "devopstest.${var.app_environment}.g8w.co"
  zone = var.zone_id
}

module "webapp_customers" {
  source = "./../../modules/webapp"
  name = "customers"
  bucket_name = "bucket3-${var.app_environment}"
  domain_name= "devopstest.${var.app_environment}.g8w.co"
  zone = var.zone_id
}

module "webapp_info" {
  source = "./../../modules/webapp"
  name = "info"
  bucket_name = "bucket2-${var.app_environment}"
  domain_name= "devopstest.${var.app_environment}.g8w.co"
  zone = var.zone_id
}

output "cloudfront_arn_auth"  {
  value = module.webapp_auth.cloudfront_arn
}
output "cloudfront_arn_info"  {
  value = module.webapp_info.cloudfront_arn
}
output "cloudfront_customers_id" {
  value = module.webapp_customers.cloudfront_id
}
