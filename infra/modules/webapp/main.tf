
module "website" {
  source = "../s3"
  name = var.name
  bucket_name = var.bucket_name
  bucket_cors = var.bucket_cors
}


module "cloudfront" {
  source = "../cloudfront"
  domain_name = module.website.s3_endpoint
  custom_origin_headers = var.custom_origin_headers
  name = var.name
  default_root_object = var.default_root_object
  dns = var.dns
  cache_policy_id = var.cache_policy_id
  forward_query_string = var.forward_query_string
  forwarded_headers = var.forwarded_headers
  origin_request_policy_id = var.origin_request_policy_id
  response_headers_policy_id = var.response_headers_policy_id
  custom_behaviors = var.custom_behaviors
  price_class = var.price_class
  geolocations = var.geolocations
  error_403_page_path = var.error_403_page_path
  error_403_page_code = var.error_403_page_code
  error_404_page_path = var.error_403_page_path
  error_404_page_code = var.error_403_page_code
  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
}

resource "aws_route53_record" "website" {
  zone_id = var.zone
  name    = var.dns
  type    = "A"

  alias {
    name                   = module.cloudfront.domain_name
    zone_id                = module.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}
/*
resource "aws_route53_record" "website_redirect_apex" {
  count   = var.apex_redirect ? 1 : 0
  zone_id = var.zone
  name    = "www.${var.dns}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_redirect_apex[count.index].domain_name
    zone_id                = aws_cloudfront_distribution.website_redirect_apex[count.index].hosted_zone_id
    evaluate_target_health = false
  }
}*/

resource "aws_acm_certificate" "cert" {
  domain_name               = var.dns
  validation_method         = "DNS"
  provider                  = aws.acm
  subject_alternative_names = var.apex_redirect ? [local.www_dns] : null

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  allow_overwrite = var.can_overwrite
  name            = element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_name
  type            = element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_type
  zone_id         = var.zone
  records         = [element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_value]
  ttl             = 60
}
/*
resource "aws_route53_record" "cert_validation_alt" {
  allow_overwrite = var.can_overwrite
  count           = var.apex_redirect ? 1 : 0
  name            = element(tolist(aws_acm_certificate.cert.domain_validation_options), 1).resource_record_name
  type            = element(tolist(aws_acm_certificate.cert.domain_validation_options), 1).resource_record_type
  zone_id         = var.zone
  records         = [element(tolist(aws_acm_certificate.cert.domain_validation_options), 1).resource_record_value]
  ttl             = 60
}*/

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = var.apex_redirect ? [aws_route53_record.cert_validation.fqdn, aws_route53_record.cert_validation_alt[0].fqdn] : [aws_route53_record.cert_validation.fqdn]
}

