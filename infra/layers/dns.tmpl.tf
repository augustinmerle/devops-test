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

#resource "aws_route53_record" "website" {
#  zone_id = "{{zone_id}}"
#  name    = "devopstest.{{dns}}"
#  type    = "A"
#  alias {
#    name                   = module.main_cloudfront.domain_name
#    zone_id                = module.main_cloudfront.hosted_zone_id
#    evaluate_target_health = false
#  }
#}
resource "aws_acm_certificate" "cert" {
  domain_name               = "devopstest.{{dns}}"
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
  zone_id         = "{{zone_id}}"
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



