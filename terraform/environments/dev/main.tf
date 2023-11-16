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
      name = "dev-platform"
    }
  }
}
provider "aws" {
  region = var.aws_region
  profile = "g8w-dev"
}
provider "aws" {
  alias  = "acm"
  region = "us-east-1"
  profile = "g8w-dev"
}

resource "aws_route53_record" "website_domain" {
  zone_id = var.zone_id
  name    = "devopstest.${var.app_environment}.g8w.co"
  type    = "A"
  alias {
    name                   = module.main_cloudfront.domain_name
    zone_id                = var.zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name               = "devopstest.${var.app_environment}.g8w.co"
  validation_method         = "DNS"
  provider                  = aws.acm
  subject_alternative_names = null

  lifecycle {
    create_before_destroy = true
  }
}
variable "can_overwrite" {
  type        = bool
  default     = true
  description = "Allow overwriting route53 records for pre-existing CNAME/certificates"
}

resource "aws_route53_record" "cert_validation" {
  allow_overwrite = var.can_overwrite
  name            = element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_name
  type            = element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_type
  zone_id         = var.zone_id
  records         = [element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_value]
  ttl             = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

module "main_cloudfront" {
  source = "../../modules/cloudfront"
  domain_name = "devopstest.dev.g8w.co"
  name = "main-lb-cf"
  dns = "devopstest.dev.g8w.co"
  origin_target_id = "website-customers-s3"
  custom_behaviors = [
    {
      path_pattern =  "/auth/*"
      target_origin_id = module.webapp_auth.cloudfront_id
    },
    {
      path_pattern =  "/customers/*"
      target_origin_id = module.webapp_customers.cloudfront_id
    },
    {
      path_pattern =  "/info/*"
      target_origin_id = module.webapp_info.cloudfront_id
    }
  ]

  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
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

module "webapp_auth" {
  source = "../../modules/webapp"
  name = "auth"
  bucket_name = "bucket1-${var.app_environment}"
  domain_name= "devopstest.${var.app_environment}.g8w.co"
  zone = var.zone_id
  origin_target_id = "bucket1-${var.app_environment}-endpoint"
  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
}

module "webapp_customers" {
  source = "../../modules/webapp"
  name = "customers"
  bucket_name = "bucket3-${var.app_environment}"
  domain_name= "devopstest.${var.app_environment}.g8w.co"
  zone = var.zone_id
  origin_target_id = "bucket3-${var.app_environment}-endpoint"
  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
}

module "webapp_info" {
  source = "../../modules/webapp"
  name = "info"
  bucket_name = "bucket2-${var.app_environment}"
  domain_name= "devopstest.${var.app_environment}.g8w.co"
  zone = var.zone_id
  origin_target_id = "bucket2-${var.app_environment}-endpoint"
  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
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
