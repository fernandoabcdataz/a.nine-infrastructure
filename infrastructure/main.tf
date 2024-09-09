provider "google" {
  project     = var.project
  region      = var.region
  credentials = file("../service-account.json")
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
  region2             = var.region2
  client_name        = var.client_name
  xero_client_id     = var.xero_client_id
  xero_client_secret = var.xero_client_secret
}

module "knowledge_base" {
  source = "./modules/knowledge_base"
  
  project             = var.project
  region              = var.region
  region2              = var.region2
  openai_api_key      = var.openai_api_key
}

module "transformation" {
  source = "./modules/transformation"
  
  project            = var.project
  region             = var.region
  region2             = var.region2
  client_name        = var.client_name
}