# Cloud Storage Bucket
resource "google_storage_bucket" "knowledge_base" {
  name     = "ai-assistant-knowledge-base"
  location = var.region
}

# BigQuery Dataset and Table
resource "google_bigquery_dataset" "knowledge_base" {
  dataset_id = "knowledge_base"
  location   = var.region
}

resource "google_bigquery_table" "semantic_model_vector" {
  dataset_id = google_bigquery_dataset.knowledge_base.dataset_id
  table_id   = "semantic_model_vector"

  schema = jsonencode([
    {
      name = "entity",
      type = "STRING"
    },
    {
      name = "chunk_id",
      type = "STRING"
    },
    {
      name = "text_chunk",
      type = "STRING"
    },
    {
      name = "embedding",
      type = "FLOAT64",
      mode = "REPEATED"
    }
  ])
}

# Secret Manager
resource "google_secret_manager_secret" "openai_api_key" {
  secret_id = "openai_api_key"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "openai_api_key" {
  secret      = google_secret_manager_secret.openai_api_key.id
  secret_data = var.openai_api_key
}

# Cloud Run Service
resource "google_cloud_run_service" "knowledge_base_processor" {
  name     = "knowledge-base-processor"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project}/knowledge-base-processor:latest"
        env {
          name  = "GCP_PROJECT"
          value = var.project
        }
        env {
          name  = "BIGQUERY_DATASET"
          value = google_bigquery_dataset.knowledge_base.dataset_id
        }
        env {
          name  = "BIGQUERY_TABLE"
          value = google_bigquery_table.semantic_model_vector.table_id
        }
        env {
          name  = "STORAGE_BUCKET"
          value = google_storage_bucket.knowledge_base.name
        }
      }
      service_account_name = "knowledge-base-sa@${var.project}.iam.gserviceaccount.com"
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# IAM binding for invoking the Cloud Run service
resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.knowledge_base_processor.name
  location = google_cloud_run_service.knowledge_base_processor.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Cloud Storage trigger for Cloud Run
resource "google_storage_notification" "notification" {
  bucket         = google_storage_bucket.knowledge_base.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.topic.id
  event_types    = ["OBJECT_FINALIZE"]
  custom_attributes = {
    new-attribute = "new-attribute-value"
  }
  depends_on = [google_pubsub_topic_iam_member.binding]
}

resource "google_pubsub_topic" "topic" {
  name = "cloud-run-storage-trigger"
}

resource "google_pubsub_topic_iam_member" "binding" {
  topic  = google_pubsub_topic.topic.id
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

data "google_storage_project_service_account" "gcs_account" {
}

resource "google_cloud_run_service_iam_member" "pubsub_invoker" {
  service  = google_cloud_run_service.knowledge_base_processor.name
  location = google_cloud_run_service.knowledge_base_processor.location
  role     = "roles/run.invoker"
  member   = "serviceAccount:knowledge-base-sa@${var.project}.iam.gserviceaccount.com"
}

data "google_project" "project" {
}