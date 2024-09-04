provider "google" {
  project     = var.project
  region      = var.region
  credentials = file("../service-account.json")
}

module "ai_assistant" {
  source = "./modules/ai_assistant"
  
  project             = var.project
  region              = var.region
  project_owner_email = var.project_owner_email
}

module "ingestion" {
  source = "./modules/ingestion"
  
  project             = var.project
  region              = var.region
  client_name         = var.client_name
  project_owner_email = var.project_owner_email
}

module "xero" {
  source = "./modules/ingestion/xero"
  
  project            = var.project
  region             = var.region
  client_name        = var.client_name
  xero_client_id     = var.xero_client_id
  xero_client_secret = var.xero_client_secret
}