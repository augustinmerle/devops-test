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
      name = "preprod-platform-main_lb"
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


resource "aws_route53_record" "website" {
  zone_id = "Z060497011SI50TIA0K9T"
  name    = "devopstest."
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
  domain_name = "devopstest."
  name = "main-lb-cf"
  dns = "devopstest."

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
