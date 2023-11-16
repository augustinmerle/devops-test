output "cloudfront_id" {
  value = module.cloudfront.cloudfront_id
}
output "cloudfront_arn" {
  value = module.cloudfront.cloudfront_arn
}

output "bucket_arn" {
  value = module.website.bucket_arn
}
output "bucket_id" {
  value = module.website.bucket_id
}
output "bucket_name" {
  value = module.website.bucket_name
}
