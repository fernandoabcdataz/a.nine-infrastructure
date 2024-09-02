resource "google_storage_bucket" "xero_data_bucket" {
  name          = "${var.project}-${var.client_name}-xero-data"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_secret_manager_secret" "client_id" {
  secret_id = "${var.project}-${var.client_name}-xero-client-id"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "client_id_version" {
  secret      = google_secret_manager_secret.client_id.id
  secret_data = var.xero_client_id
}

resource "google_secret_manager_secret" "client_secret" {
  secret_id = "${var.project}-${var.client_name}-xero-client-secret"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "client_secret_version" {
  secret      = google_secret_manager_secret.client_secret.id
  secret_data = var.xero_client_secret
}