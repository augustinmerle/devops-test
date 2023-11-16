resource "aws_cloudfront_distribution" "s3distribution" {
  origin {
    domain_name = var.domain_name
#    origin_path = "/${var.name}"
    origin_id   = var.origin_target_id
    custom_origin_config {
      // These are all the defaults.
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
    dynamic "custom_header" {
      for_each = var.custom_origin_headers
      content {
        name  = custom_header.value.name
        value = custom_header.value.value
      }
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "s3distribution ${var.name}"
  default_root_object = var.default_root_object

  aliases = (var.dns != "")?[var.dns]: null

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_target_id
    dynamic "forwarded_values" {
      for_each = (null != var.cache_policy_id) ? {} : { x : true }
      content {
        query_string = var.forward_query_string
        cookies {
          forward = "none"
        }
        headers = var.forwarded_headers
      }
    }


    viewer_protocol_policy     = "redirect-to-https"
    min_ttl                    = 0
    default_ttl                = 3600
    max_ttl                    = 86400
    compress                   = true
    cache_policy_id            = var.cache_policy_id
    origin_request_policy_id   = var.origin_request_policy_id
    response_headers_policy_id = var.response_headers_policy_id

  }

  dynamic "ordered_cache_behavior" {
    for_each = var.custom_behaviors != null ? var.custom_behaviors : []
    content {
      path_pattern               = ordered_cache_behavior.value["path_pattern"]
      allowed_methods            = lookup(ordered_cache_behavior.value, "allowed_methods", ["GET", "HEAD"])
      cached_methods             = lookup(ordered_cache_behavior.value, "cached_methods", ["GET", "HEAD"])
      target_origin_id           = lookup(ordered_cache_behavior.value, "target_origin_id", local.origin_target_id)
      compress                   = lookup(ordered_cache_behavior.value, "compress", true)
      viewer_protocol_policy     = lookup(ordered_cache_behavior.value, "viewer_protocol_policy", "redirect-to-https")
      origin_request_policy_id   = lookup(ordered_cache_behavior.value, "origin_request_policy_id", null)
      cache_policy_id            = lookup(ordered_cache_behavior.value, "cache_policy_id", null)
      response_headers_policy_id = lookup(ordered_cache_behavior.value, "response_headers_policy_id", null)
      forwarded_values {
        query_string = false
        cookies {
          forward = "none"
        }
      }
    }

  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = length(var.geolocations) == 0 ? "none" : "whitelist"
      locations        = length(var.geolocations) == 0 ? null : var.geolocations
    }
  }

  tags = {
  }

  viewer_certificate {

    cloudfront_default_certificate = var.certificate_arn != "" ?false:true
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  dynamic "custom_error_response" {
    for_each = toset(("" == var.error_403_page_path) ? [] : [var.error_403_page_path])
    content {
      error_code         = 403
      response_code      = var.error_403_page_code
      response_page_path = custom_error_response.value
    }
  }

  dynamic "custom_error_response" {
    for_each = toset(("" == var.error_404_page_path) ? [] : [var.error_404_page_path])
    content {
      error_code         = 404
      response_code      = var.error_404_page_code
      response_page_path = custom_error_response.value
    }
  }
}

