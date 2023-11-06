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

module "s3_bucket_auth" {
  source      = "../../modules/s3"
  bucket_name = "bucket1_dev"
}

module "cloudfront_distribution_auth" {
  source              = "../../modules/cloudfront"
  s3_bucket_domain_name = "info.{{dns}}"
  origin_id           = "S3-bucket1_{{env}}"
}
