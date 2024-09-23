provider "google" {
  project = var.project
  region  = var.region
}

data "google_project" "current" {}

# =====================================
# Global Security: Master Service Account
# =====================================

module "security" {
  source   = "./modules/security"
  project  = var.project
  clients  = var.clients
}

# =====================================
# Ingestion Services
# =====================================

module "ingestion" {
  source                 = "./modules/ingestion"
  project                = var.project
  location               = var.region
  clients                = var.clients
  ingestion_image        = var.ingestion_image
  security_module_output = module.security.client_service_accounts
}

# =====================================
# Transformation Services
# =====================================

module "transformation" {
  source                     = "./modules/transformation"
  project                    = var.project
  location                   = var.region
  clients                    = var.clients
  transformation_image       = var.transformation_image
  security_module_output     = module.security.client_service_accounts
}

# =====================================
# Assistant Service (Shared LLM Compute)
# =====================================

module "assistant" {
  source                = "./modules/assistant"
  project               = var.project
  location              = var.region
  assistant_image       = var.assistant_image
  master_service_account = module.security.master_sa.email
}

# =====================================
# Outputs
# =====================================

output "ingestion_urls" {
  description = "Map of ingestion Cloud Run service URLs."
  value       = module.ingestion.ingestion_urls
}

output "transformation_urls" {
  description = "Map of transformation Cloud Run service URLs."
  value       = module.transformation.transformation_urls
}

output "assistant_url" {
  description = "URL of the Assistant Cloud Run service."
  value       = module.assistant.assistant_url
}