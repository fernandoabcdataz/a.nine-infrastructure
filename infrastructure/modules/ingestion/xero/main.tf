resource "google_service_account" "cloud_run_sa" {
  account_id   = "${var.client_name}-cloud-run-sa"
  display_name = "${var.client_name} Cloud Run Service Account"
}

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

resource "google_project_iam_member" "cloud_run_image_puller" {
  project = "${var.project}"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:service-${data.google_project.current.number}@serverless-robot-prod.iam.gserviceaccount.com"
}

data "google_project" "current" {}

# Cloud Run Service
resource "google_cloud_run_service" "xero_service" {
  name     = "${var.project}-${var.client_name}-cloud-run-xero"
  location = var.region2

  template {
    spec {
      containers {
        image = "gcr.io/${var.project}/${var.client_name}-xero:latest"
        ports {
          container_port = 8080
        }
        env {
          name  = "CLIENT_NAME"
          value = var.client_name
        }
        env {
          # name  = "GCP_PROJECT"
          name  = "GOOGLE_CLOUD_PROJECT"
          value = var.project
        }
      }
      service_account_name = "developer-sa@${var.project}.iam.gserviceaccount.com"
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

/*
# iam entry for the service account to invoke the cloud run service
resource "google_cloud_run_service_iam_member" "run_invoker" {
  service  = google_cloud_run_service.xero_service.name
  location = google_cloud_run_service.xero_service.location
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}
*/

# cloud scheduler job
resource "google_cloud_scheduler_job" "xero_hourly_job" {
  name             = "${var.project}-${var.client_name}-scheduler-xero-hourly"
  description      = "Triggers Xero data ingestion hourly"
  schedule         = "0 * * * *"
  time_zone        = "Australia/Sydney"
  attempt_deadline = "320s"

  http_target {
    http_method = "POST"
    uri         = "${google_cloud_run_service.xero_service.status[0].url}/run"

    oidc_token {
      service_account_email = "developer-sa@${var.project}.iam.gserviceaccount.com"
      # service_account_email = google_service_account.cloud_run_sa.email
      audience              = google_cloud_run_service.xero_service.status[0].url
    }
  }
}