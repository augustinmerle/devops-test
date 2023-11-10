variable "domain_name" {}
variable "custom_origin_headers" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
variable "name" {}
variable "default_root_object" {
  type    = string
  default = "index.html"
}
variable "dns" {
  type = string
}
variable "cache_policy_id" {
  type    = string
  default = null
}
variable "forward_query_string" {
  type    = bool
  default = false
}
variable "forwarded_headers" {
  type    = list(string)
  default = null
}
variable "origin_request_policy_id" {
  type    = string
  default = null
}
variable "response_headers_policy_id" {
  type    = string
  default = null
}
variable "custom_behaviors" {
  type    = list(any)
  default = null
}
variable "price_class" {
  type    = string
  default = "PriceClass_100"
}
variable "geolocations" {
  type    = list(string)
  default = ["FR", "BE", "LU", "IT", "ES", "CH", "NL", "GB", "PT", "MC"]
}
variable "error_403_page_path" {
  type    = string
  default = ""
}
variable "error_404_page_path" {
  type    = string
  default = ""
}
variable "error_403_page_code" {
  type    = number
  default = 200
}
variable "error_404_page_code" {
  type    = number
  default = 200
}
variable "certificate_arn" {
  type = string
}



