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

variable "project_owner_email" {
  description = "email address of the project owner"
  type        = string
}