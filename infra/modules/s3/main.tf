resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
  tags = {
    Website = var.name
  }
}
resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website.id
  acl    = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.website,
    aws_s3_bucket_public_access_block.website,
  ]
}
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.s3_website_policy.json
  depends_on = [
    aws_s3_bucket_ownership_controls.website,
    aws_s3_bucket_public_access_block.website,
  ]
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket

  index_document {
    suffix = var.index_document
  }
  error_document {
    key = ("" == var.error_document) ? var.index_document : var.error_document
  }
}
resource "aws_s3_bucket_cors_configuration" "website" {
  count  = (var.bucket_cors == true) ? 1 : 0
  bucket = aws_s3_bucket.website.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["POST", "GET", "PUT", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
/*
resource "aws_s3_bucket" "website_redirect_apex" {
  count  = var.apex_redirect ? 1 : 0
  bucket = "www.${var.bucket_name}"
  tags = {
    Website = var.name
  }
}
resource "aws_s3_bucket_acl" "website_redirect_apex" {
  count  = var.apex_redirect ? 1 : 0
  bucket = aws_s3_bucket.website_redirect_apex[0].id
  acl    = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.website_redirect_apex[0],
    aws_s3_bucket_public_access_block.website_redirect_apex[0],
  ]
}
resource "aws_s3_bucket_public_access_block" "website_redirect_apex" {
  count  = var.apex_redirect ? 1 : 0
  bucket = aws_s3_bucket.website_redirect_apex[0].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_ownership_controls" "website_redirect_apex" {
  count  = var.apex_redirect ? 1 : 0
  bucket = aws_s3_bucket.website_redirect_apex[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_website_configuration" "website_redirect_apex" {
  count  = var.apex_redirect ? 1 : 0
  bucket = aws_s3_bucket.website_redirect_apex[0].bucket

  redirect_all_requests_to {
    host_name = var.dns
    protocol  = "https"
  }
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
*/
