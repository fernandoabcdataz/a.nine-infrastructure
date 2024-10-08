resource "google_bigquery_dataset" "ingestion_dataset" {
  dataset_id                  = "${var.client_name}_ingestion"
  friendly_name               = "${var.client_name} Ingestion Dataset"
  description                 = "dataset for ingested data"
  location                    = var.region
  default_table_expiration_ms = null

  labels = {
    environment = "production"
  }
}

output "ingestion_dataset_id" {
  value       = google_bigquery_dataset.ingestion_dataset.dataset_id
  description = "the ID of the ingestion dataset"
}