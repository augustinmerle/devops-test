

output "bucket_arn" {
  value = aws_s3_bucket.website.arn
}
output "bucket_id" {
  value = aws_s3_bucket.website.id
}
output "bucket_name" {
  value = aws_s3_bucket.website.bucket
}
output "s3_endpoint" {
  value = aws_s3_bucket.website.website_endpoint
}
