variable "project" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region where resources will be created"
  type        = string
}

variable "region2" {
  description = "Google Cloud region where cloud run will be created"
  type        = string
}

variable "openai_api_key" {
  description = "OpenAI API Key"
  type        = string
}