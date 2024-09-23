output "ingestion_urls" {
  description = "Map of ingestion Cloud Run service URLs."
  value       = { for client, service in google_cloud_run_service.ingestion : client => service.status[0].url }
}