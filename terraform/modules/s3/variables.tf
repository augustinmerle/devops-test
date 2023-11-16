variable "bucket_name" {
  type = string
}
variable "name" {
  type = string
}
variable "index_document" {
  type    = string
  default = "index.html"
}
variable "error_document" {
  type    = string
  default = ""
}
variable "bucket_cors" {
  type    = bool
  default = false
}

