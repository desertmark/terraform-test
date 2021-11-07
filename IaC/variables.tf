variable "location" {
  description = "Azure location for the resources"
  default     = "westeurope"
}

variable "env" {
  description = "environment, dev|stage|prod"
}

variable "domain" {
  description = "Domain to use i.e: mydomain.com"
}