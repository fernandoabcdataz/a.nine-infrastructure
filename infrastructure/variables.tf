variable "project" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region where resources will be created"
  type        = string
  default     = "australia-southeast1"
}

variable "client_name" {
  description = "name of the client, used for naming resources"
  type        = string
}

variable "xero_client_id" {
  description = "Client ID for Xero API integration"
  type        = string
  sensitive   = true
}

variable "xero_client_secret" {
  description = "Client Secret for Xero API integration"
  type        = string
  sensitive   = true
}

variable "project_owner_email" {
  description = "email address of the project owner"
  type        = string
}

variable "data_ingestion_sa" {
  description = "email of the data ingestion service account"
  type        = string
  default     = "data-ingestion-sa@${var.project}.iam.gserviceaccount.com"
}

variable "environment" {
  description = "environment (e.g., 'dev', 'prod')"
  type        = string
  default     = "dev"
}