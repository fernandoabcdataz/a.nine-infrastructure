output "client_service_accounts" {
  description = "Map of client service account emails."
  value       = { for client, sa in google_service_account.client_sa : client => sa.email }
}