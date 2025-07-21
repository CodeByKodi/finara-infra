resource "google_service_account" "finara_backend_sa" {
  account_id   = "finara-backend"
  display_name = "Finara Backend Service Account"
}

resource "google_service_account_key" "backend_key" {
  service_account_id = google_service_account.finara_backend_sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

output "firebase_admin_key_json" {
  value     = google_service_account_key.backend_key.private_key
  sensitive = true
}

resource "null_resource" "enable_firebase" {
  provisioner "local-exec" {
    command = <<EOT
  ACCESS_TOKEN=$(gcloud auth application-default print-access-token)
  curl -s -X POST \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    "https://firebase.googleapis.com/v1beta1/projects/${var.project_id}:addFirebase"
EOT
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [google_service_account_key.backend_key]
}