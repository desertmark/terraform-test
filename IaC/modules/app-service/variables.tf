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
  type    = string
  default = null
}

variable "nginx_ips" {
  type    = list(string)
  default = null
}

variable "tier" {
  type = string
}

variable "size" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "subnet id for vnet integration. Requires 'Standard' Tier."
  default     = null
}

variable "vnet_integration" {
  type        = bool
  description = "vnet integration enabled. Requires 'Standard' Tier."
  default     = false
}

variable "include_dns_record" {
  type    = bool
  default = false
}

variable "zone_name" {
  type        = string
  description = "DNS Zone name where public IP should be registered in."
  default     = null
}
variable "zone_name_rg" {
  type        = string
  description = "DNS Zone resource group name."
  default     = null
}
variable "dns_record_name" {
  type    = string
  default = null
}
