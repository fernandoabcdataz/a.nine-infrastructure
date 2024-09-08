variable "project" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region where resources will be created"
  type        = string
}

variable "region2" {
  description = "Google Cloud region where secret manager will be created"
  type        = string
  default     = "australia-southeast1"
}

variable "openai_api_key" {
  description = "OpenAI API Key"
  type        = string
}