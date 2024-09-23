resource "google_service_account" "client_sa" {
  for_each    = var.clients
  account_id   = "${each.key}-service-account"
  display_name = "${each.key} Service Account"
}

resource "google_project_iam_member" "client_roles" {
  for_each = {
    for client, roles in var.clients : 
    "${client}-bigquery-editor" => {
      client = client
      role   = "roles/bigquery.dataEditor"
    },
    "${client}-secret-accessor" => {
      client = client
      role   = "roles/secretmanager.secretAccessor"
    },
    "${client}-storage-viewer" => {
      client = client
      role   = "roles/storage.objectViewer"
    }
  }

  project = var.project
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.client_sa[each.value.client].email}"
}