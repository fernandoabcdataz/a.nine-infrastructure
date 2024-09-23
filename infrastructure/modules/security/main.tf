locals {
  # define all roles for each client
  client_roles = flatten([
    for client in keys(var.clients) : [
      {
        name   = "${client}-bigquery-editor"
        client = client
        role   = "roles/bigquery.dataEditor"
      },
      {
        name   = "${client}-secret-accessor"
        client = client
        role   = "roles/secretmanager.secretAccessor"
      },
      {
        name   = "${client}-storage-viewer"
        client = client
        role   = "roles/storage.objectViewer"
      }
    ]
  ])
}

# master service account
resource "google_service_account" "master_sa" {
  account_id   = "master-service-account"
  display_name = "Master Service Account"
}

# client Service Accounts
resource "google_service_account" "client_sa" {
  for_each    = var.clients
  account_id  = "${each.key}-service-account"
  display_name = "${each.key} Service Account"
}

# assign IAM Roles to Client Service Accounts
resource "google_project_iam_member" "client_roles" {
  for_each = { for role in local.client_roles : role.name => role }

  project = var.project
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.client_sa[each.value.client].email}"
}

# assign IAM Roles to Master Service Account (if needed)
resource "google_project_iam_member" "master_roles" {
  for_each = toset([
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    # Add other necessary roles
  ])

  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.master_sa.email}"
}