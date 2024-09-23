resource "google_cloud_run_service" "transformation" {
  for_each = var.clients

  name     = "${var.project}-${each.key}-transformation"
  location = var.location

  template {
    spec {
      service_account_name = var.security_module_output[each.key]

      # Correct placement of container_concurrency
      container_concurrency = var.container_concurrency

      containers {
        image = var.transformation_image
        ports {
          container_port = 8080
        }

        env {
          name  = "CLIENT_NAME"
          value = each.key
        }

        env {
          name  = "GCP_PROJECT"
          value = var.project
        }

        # Inject secrets
        env {
          name = "XERO_CLIENT_ID"
          value_from {
            secret_key_ref {
              name = "${var.project}-${each.key}-xero-client-id"
              key  = "latest"
            }
          }
        }

        env {
          name = "XERO_CLIENT_SECRET"
          value_from {
            secret_key_ref {
              name = "${var.project}-${each.key}-xero-client-secret"
              key  = "latest"
            }
          }
        }

        resources {
          limits = {
            memory = "1Gi"
            cpu    = "1"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  for_each = { for client in var.clients : client => {
    service = google_cloud_run_service.transformation[client].name
    role    = "roles/run.invoker"
    member  = "serviceAccount:service-${data.google_project.current.number}@serverless-robot-prod.iam.gserviceaccount.com"
  } }

  service  = each.value.service
  location = var.location
  role     = each.value.role
  member   = each.value.member
}

# optional: Add Cloud Scheduler or Pub/Sub triggers here as needed