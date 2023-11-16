variable "zone_id" {
  type = string
  description = "AWS route 53 zone ID"
}
variable "app_name" {
  type = string
  description = "global application name (for dns use)"
}

variable "aws_region" {
  type = string
  description = "AWS region name"
  default = "eu-west-3"
}
variable "app_environment" {
  type = string
  description = "environnement name"
  default = "dev"
}
variable "root_dns" {
  type = string
  description = "Root dns url"
}
