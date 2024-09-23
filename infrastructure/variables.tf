variable "project" {
  description = "GCP Project ID."
  type        = string
}

variable "region" {
  description = "GCP region for resources."
  type        = string
}

variable "clients" {
  description = "Map of clients to provision resources for."
  type = map(object({
    # Define any client-specific attributes if needed
    # For simplicity, using empty objects here
  }))
}

variable "ingestion_image" {
  description = "Docker image for ingestion services."
  type        = string
}

variable "transformation_image" {
  description = "Docker image for transformation services."
  type        = string
}

variable "assistant_image" {
  description = "Docker image for assistant service."
  type        = string
}