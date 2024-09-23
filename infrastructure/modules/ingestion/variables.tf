variable "project" {
  description = "GCP Project ID."
  type        = string
}

variable "location" {
  description = "GCP region for Cloud Run services."
  type        = string
}

variable "clients" {
  description = "Map of clients."
  type        = map(any)
}

variable "ingestion_image" {
  description = "Docker image for ingestion service."
  type        = string
}

variable "security_module_output" {
  description = "Map of client service account emails."
  type        = map(string)
}