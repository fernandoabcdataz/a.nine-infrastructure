output "assistant_url" {
  description = "URL of the Assistant Cloud Run service."
  value       = google_cloud_run_service.assistant.status[0].url
}