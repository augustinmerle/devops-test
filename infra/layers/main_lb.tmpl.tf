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

  custom_behaviors = [
    {
      path_pattern =  "/customers/*"
      target_origin_id = "bucket3-dev.s3-website"
      //target_origin_id = data.terraform_remote_state.customers.outputs.cloudfront_customers_id
    }
  ]

  certificate_arn = data.terraform_remote_state.dns.outputs.certificate_arn
}
#
#resource "aws_cloudfront_distribution" "main_distribution" {
#  origin {
#    domain_name = aws_acm_certificate.cert.domain_name
#    origin_id   = "mainOrigin"
#    // Configuration de l'origine principale
#    // ...
#  }
#
#  enabled = true
#
#  aliases = [aws_acm_certificate.cert.domain_name]
#
#  default_cache_behavior {
#
#  }
#
#  ordered_cache_behavior {
#    path_pattern     = "/auth/*"
#    target_origin_id = data.terraform_remote_state.auth.outputs.cloudfront_arn
#    // Configuration spécifique pour /auth
#    // ...
#  }
#
#  ordered_cache_behavior {
#    path_pattern     = "/info/*"
#    target_origin_id = data.terraform_remote_state.info.outputs.cloudfront_arn
#    // Configuration spécifique pour /info
#    // ...
#  }
#
#  ordered_cache_behavior {
#    path_pattern     = "/customers/*"
#    target_origin_id = data.terraform_remote_state.customers.outputs.cloudfront_arn
#    // Configuration spécifique pour /customers
#    // ...
#  }
#
#  viewer_certificate {
#    acm_certificate_arn            = "your_acm_certificate_arn"
#    ssl_support_method             = "sni-only"
#    minimum_protocol_version       = "TLSv1.2_2019"
#    cloudfront_default_certificate = false
#  }
#
#  // Autres configurations...
#}
