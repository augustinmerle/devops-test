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

module "webapp_info" {
  source = "../../../modules/webapp"
  bucket_name = "bucket2-{{env}}"
  name = "info"
  domain_name= "devopstest.{{dns}}"
  zone = "{{zone_id}}"
}

output "cloudfront_arn_info"  {
  value = module.webapp_info.cloudfront_arn
}
