variable "project" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region where resources will be created"
  type        = string
}

variable "client_name" {
  description = "name of the client, used for naming resources"
  type        = string
}

variable "xero_client_id" {
  description = "Client ID for Xero API integration"
  type        = string
}

variable "xero_client_secret" {
  description = "Client Secret for Xero API integration"
  type        = string
}

variable "project_owner_email" {
  description = "email address of the project owner"
  type        = string
}