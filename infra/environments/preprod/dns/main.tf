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
      name = "preprod-platform-dns"
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

#resource "aws_route53_record" "website" {
#  zone_id = ""
#  name    = "devopstest.staging.g8w.co"
#  type    = "A"
#  alias {
#    name                   = module.main_cloudfront.domain_name
#    zone_id                = module.main_cloudfront.hosted_zone_id
#    evaluate_target_health = false
#  }
#}
resource "aws_acm_certificate" "cert" {
  domain_name               = "devopstest.staging.g8w.co"
  validation_method         = "DNS"
  provider                  = aws.acm
  subject_alternative_names = null

  lifecycle {
    create_before_destroy = true
  }
}
variable "can_overwrite" {
  type        = bool
  default     = false
  description = "Allow overwriting route53 records for pre-existing CNAME/certificates"
}

resource "aws_route53_record" "cert_validation" {
  allow_overwrite = var.can_overwrite
  name            = element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_name
  type            = element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_type
  zone_id         = ""
  records         = [element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_value]
  ttl             = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

output "certificate_arn" {
  value = aws_acm_certificate_validation.cert.certificate_arn
}



