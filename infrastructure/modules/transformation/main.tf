resource "google_bigquery_dataset" "analytics_dataset" {
  dataset_id                  = "${var.client_name}_analytics"
  friendly_name               = "${var.client_name} Analytics Dataset"
  description                 = "Dataset for ingested data"
  location                    = var.region
  default_table_expiration_ms = null

  labels = {
    environment = "production"
  }
}

# Cloud Run Service
resource "google_cloud_run_service" "dbt_service" {
  name     = "${var.client_name}-dbt-service"
  location = var.region2

  template {
    spec {
      containers {
        image = "gcr.io/${var.project}/dbt-image:latest"
        env {
          name  = "GCP_PROJECT"
          value = var.project
        }
        env {
          name  = "CLIENT_NAME"
          value = var.client_name
        }
        ports {
          container_port = 8080
        }
      }
      service_account_name = "developer-sa@${var.project}.iam.gserviceaccount.com"
    }
  }
}