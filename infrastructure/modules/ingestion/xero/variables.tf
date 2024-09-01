variable "project" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud Region"
  type        = string
  default     = "australia-southeast1"
}

variable "client_name" {
  description = "Client Name"
  type        = string
}

variable "xero_client_id" {
  description = "Xero API Client ID"
  type        = string
  sensitive   = true
}

variable "xero_client_secret" {
  description = "Xero API Client Secret"
  type        = string
  sensitive   = true
}

variable "project_owner_email" {
  description = "email of the project owner"
  type        = string
}

variable "create_if_not_exists" {
  type    = bool
  default = false
}
