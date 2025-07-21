output "firebase_admin_sdk_key_json" {
  value     = google_service_account_key.backend_key.private_key
  sensitive = true
}

# output "firebase_web_api_key" {
#   value     = jsondecode(data.local_file.firebase_output.content).apiKey
#   sensitive = true
# }

# output "gemini_api_key_secret_id" {
#   value = google_secret_manager_secret.gemini_api_key.id
# }