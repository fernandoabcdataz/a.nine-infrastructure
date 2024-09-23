output "client_service_accounts" {
  description = "Map of client service account emails."
  value       = { for client, sa in google_service_account.client_sa : client => sa.email }
}

output "master_service_account_email" {
  description = "Email of the master service account."
  value       = google_service_account.master_sa.email
}