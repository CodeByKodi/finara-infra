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