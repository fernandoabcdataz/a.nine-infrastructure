output "transformation_urls" {
  description = "Map of transformation Cloud Run service URLs."
  value       = { for client, service in google_cloud_run_service.transformation : client => service.status[0].url }
}