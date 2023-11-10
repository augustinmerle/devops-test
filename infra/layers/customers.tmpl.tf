terraform {
  required_version = ">= {{terraform_version}}"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "{{{aws_provider_version_constraint}}}"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "{{terraform_organization}}"
    workspaces {
      name = "{{layer_full_name}}"
    }
  }
}

provider "aws" {
  region = "{{region}}"
}

provider "aws" {
  alias  = "acm"
  region = "{{central_region}}"
}

module "webapp_customers" {
  source = "../../../modules/webapp"
  bucket_name = "bucket3-{{env}}"
  name = "customers"
  domain_name= "devopstest.{{dns}}"
  zone = "Z060497011SI50TIA0K9T"
}

output "cloudfront_customers_id" {
  value = module.webapp_customers.cloudfront_id
}
