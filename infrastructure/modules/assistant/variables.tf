variable "project" {
  description = "GCP Project ID."
  type        = string
}

variable "location" {
  description = "GCP region for Cloud Run services."
  type        = string
}

variable "assistant_image" {
  description = "Docker image for assistant service."
  type        = string
}

variable "master_service_account" {
  description = "Master service account email."
  type        = string
}