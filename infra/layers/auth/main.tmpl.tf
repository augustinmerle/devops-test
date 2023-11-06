S3



resource "aws_route53_record" "website" {
  zone_id = var.zone
  name    = var.dns
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}
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
}

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
resource "aws_route53_record" "cert_validation_alt" {
  allow_overwrite = var.can_overwrite
  count           = var.apex_redirect ? 1 : 0
  name            = element(tolist(aws_acm_certificate.cert.domain_validation_options), 1).resource_record_name
  type            = element(tolist(aws_acm_certificate.cert.domain_validation_options), 1).resource_record_type
  zone_id         = var.zone
  records         = [element(tolist(aws_acm_certificate.cert.domain_validation_options), 1).resource_record_value]
  ttl             = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = var.apex_redirect ? [aws_route53_record.cert_validation.fqdn, aws_route53_record.cert_validation_alt[0].fqdn] : [aws_route53_record.cert_validation.fqdn]
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.s3_website_policy.json
  depends_on = [
    aws_s3_bucket_ownership_controls.website,
    aws_s3_bucket_public_access_block.website,
  ]
}
resource "aws_s3_bucket_policy" "website_redirect_apex" {
  count  = var.apex_redirect ? 1 : 0
  bucket = aws_s3_bucket.website_redirect_apex[count.index].id
  policy = data.aws_iam_policy_document.s3_website_redirect_apex_policy[count.index].json
  depends_on = [
    aws_s3_bucket_ownership_controls.website_redirect_apex[0],
    aws_s3_bucket_public_access_block.website_redirect_apex[0],
  ]
}
