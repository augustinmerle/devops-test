provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

module "website" {
  source = "../s3"
  name = var.name
  bucket_name = var.bucket_name
  bucket_cors = var.bucket_cors
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
module "cloudfront" {
  source = "../cloudfront"
  domain_name = module.website.s3_endpoint
  custom_origin_headers = var.custom_origin_headers
  name = var.name
  dns = ""
  #certificate_arn=""
  certificate_arn = data.terraform_remote_state.dns.outputs.certificate_arn
}



