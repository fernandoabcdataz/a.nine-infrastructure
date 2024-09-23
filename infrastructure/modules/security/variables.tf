variable "project" {
  description = "GCP Project ID."
  type        = string
}

variable "clients" {
  description = "Map of clients to provision resources for."
  type        = map(any)
}