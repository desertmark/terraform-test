variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "name_template" {
  type = string
}

variable "app_name" {
  type        = string
  description = "Azure App Service name"
}

variable "image_name" {
  type        = string
  description = "[registry|user]/[image_name]:[tag]"
}

variable "registry_server_url" {
  type = string
}

variable "tags" {
}

variable "agw_subnet_id" {
  type = string
}
