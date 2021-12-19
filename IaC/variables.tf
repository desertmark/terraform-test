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

variable "ui_image_name" {
  description = "Docker image name to pull the image for the frontend app from. {profile}/{image_name}:{tag}"
}

variable "service_image_name" {
  description = "Docker image name to pull the image for the backend app from. {profile}/{image_name}:{tag}"
}

variable "solution" {
  description = "Name that describes the intent of the solution. i.e: todoapp"
}

variable "gateway" {
  description = "Layer 7 Gateway to use, azure|nginx"
  default = "nginx"
}