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


resource "aws_route53_record" "website" {
  zone_id = "Z060497011SI50TIA0K9T"
  name    = "devopstest.{{dns}}"
  type    = "A"
  alias {
    name                   = module.main_cloudfront.domain_name
    zone_id                = module.main_cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

data "terraform_remote_state" "dns" {
  backend = "remote"
  config  = {
    organization = "devops-test-alv"
    workspaces   = {
      name = "dev-platform-dns"
    }
  }
}
data "terraform_remote_state" "customers" {
  backend = "remote"
  config  = {
    organization = "devops-test-alv"
    workspaces   = {
      name = "dev-platform-customers"
    }
  }
}

module "main_cloudfront" {
  source = "../../../modules/cloudfront"
  domain_name = "devopstest.{{dns}}"
  name = "main-lb-cf"
  dns = "devopstest.{{dns}}"
  origin_target_id = data.terraform_remote_state.customers.outputs.cloudfront_customers_id
  custom_behaviors = [
    {
      path_pattern =  "/customers/*"
      //target_origin_id = "bucket3-dev.s3-website"
      target_origin_id = data.terraform_remote_state.customers.outputs.cloudfront_customers_id
    }
  ]

  certificate_arn = data.terraform_remote_state.dns.outputs.certificate_arn
}
