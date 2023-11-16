/*output "cache_policies" {
  value = {
    api = aws_cloudfront_cache_policy.api.id
  }
}*/
output "cloudfront_id" {
  value = aws_cloudfront_distribution.s3distribution.id
}
output "cloudfront_arn" {
  value = aws_cloudfront_distribution.s3distribution.arn
}
output "domain_name" {
  value = aws_cloudfront_distribution.s3distribution.domain_name
}
output "hosted_zone_id" {
  value = aws_cloudfront_distribution.s3distribution.hosted_zone_id
}
