variable "location" {
  type = string
}
variable "env" {
  type = string
}
variable "resource_group_name" {
  type = string
}

variable "name_template" {
  type = string
}

variable "solution" {
  type = string
}

variable "tags" {
}

variable "subnet_id" {
  type = string
}

variable "ui_hostname" {
  type        = string
  description = "Hostname of the frontend app service instance."
}

variable "service_hostname" {
  type        = string
  description = "Hostname of the backend app service instance."
}

variable "zone_name" {
  type        = string
  description = "DNS Zone name where public IP should be registered in."
}
variable "zone_name_rg" {
  type        = string
  description = "DNS Zone resource group name."
}