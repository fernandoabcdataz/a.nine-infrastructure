resource "google_cloud_run_service" "assistant" {
  name     = "${var.project}-assistant"
  location = var.location

  template {
    spec {
      service_account_name = var.master_service_account

      containers {
        image = var.assistant_image
        ports {
          container_port = 8080
        }

        env {
          name  = "GCP_PROJECT"
          value = var.project
        }

        resources {
          limits = {
            memory = "2Gi"
            cpu    = "2"
          }
        }

        container_concurrency = 20
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "assistant_invoker" {
  service  = google_cloud_run_service.assistant.name
  location = var.location
  role     = "roles/run.invoker"
  member   = "serviceAccount:service-${data.google_project.current.number}@serverless-robot-prod.iam.gserviceaccount.com"
}