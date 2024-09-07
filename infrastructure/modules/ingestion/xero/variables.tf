variable "project" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region where resources will be created"
  type        = string
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