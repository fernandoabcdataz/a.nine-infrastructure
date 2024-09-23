output "dbt_cloud_run_url" {
  description = "URL of the dbt Cloud Run service"
  value       = module.dbt_cloud_run.url
}