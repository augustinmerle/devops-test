provider "aws" {
  alias  = "acm"
  region = "us-east-1"
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

module "website" {
  source = "../s3"
  name = var.name
  bucket_name = var.bucket_name
  bucket_cors = var.bucket_cors
}

module "cloudfront" {
  source = "../cloudfront"
  domain_name = module.website.s3_endpoint
  name = var.name
  dns = ""
  custom_behaviors = [
    #    {
    #      path_pattern =  "/auth/*"
    #      target_origin_id = module.webapp_auth.cloudfront_id
    #    }
  origin_target_id = local.origin_target_id
  certificate_arn = var.certificate_arn
}



