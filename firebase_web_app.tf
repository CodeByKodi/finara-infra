# ############################################################
# # Variables
# ############################################################
# variable "firebase_webapp_display_name" {
#   description = "Display name for the Firebase Web App."
#   type        = string
#   default     = "Finara Web"
# }

# ############################################################
# # Script paths
# ############################################################
# # We'll drop the API response to a local file Terraform can read.
# locals {
#   firebase_webapp_out      = "${path.module}/firebase_webapp.json"
#   firebase_webapp_config   = "${path.module}/firebase_webapp_config.json"
# }

# ############################################################
# # Create (or detect) Firebase Web App
# #
# # Logic in shell:
# # 1. List existing web apps
# # 2. If none match displayName, create one
# # 3. Write the resulting app JSON to firebase_webapp.json
# ############################################################
# resource "null_resource" "firebase_webapp" {
#   # Re-run when display name changes or project changes
#   triggers = {
#     project_id  = var.project_id
#     displayName = var.firebase_webapp_display_name
#   }

#   provisioner "local-exec" {
#     command = <<-EOT
#       set -euo pipefail

#       ACCESS_TOKEN=$(gcloud auth application-default print-access-token)

#       # List existing apps
#       LIST=$(curl -s -H "Authorization: Bearer ${ACCESS_TOKEN}" \
#                   -H "Content-Type: application/json" \
#                   "https://firebase.googleapis.com/v1beta1/projects/${var.project_id}/webApps")

#       # Try to find an existing app with matching displayName
#       APP_ID=$(echo "$LIST" | jq -r --arg NAME "${var.firebase_webapp_display_name}" '.apps[]? | select(.displayName==$NAME) | .name' | head -n1)

#       if [ -z "$APP_ID" ] || [ "$APP_ID" = "null" ]; then
#         echo "No existing Firebase Web App named '${var.firebase_webapp_display_name}'. Creating..."
#         CREATE=$(curl -s -X POST \
#           -H "Authorization: Bearer ${ACCESS_TOKEN}" \
#           -H "Content-Type: application/json" \
#           -d '{"displayName":"${var.firebase_webapp_display_name}","platform":"WEB"}' \
#           "https://firebase.googleapis.com/v1beta1/projects/${var.project_id}/webApps")
#         echo "$CREATE" > "${local.firebase_webapp_out}"
#         echo "Web App created with ID: $APP_ID"
#         APP_ID=$(echo "$CREATE" | jq -r '.name')
#       else
#         echo "Found existing Firebase Web App: $APP_ID"
#         echo "$LIST" | jq -r --arg ID "$APP_ID" '.apps[] | select(.name==$ID)' > "${local.firebase_webapp_out}"
#       fi

#       # Fetch config for the app
#       curl -s -H "Authorization: Bearer ${ACCESS_TOKEN}" \
#            -H "Content-Type: application/json" \
#            "https://firebase.googleapis.com/v1beta1/${APP_ID}/config" \
#            > "${local.firebase_webapp_config}"

#       jq empty "${local.firebase_webapp_out}" || { echo "Error: invalid firebase_webapp.json"; exit 1; }
#       jq empty "${local.firebase_webapp_config}" || { echo "Error: invalid firebase_webapp_config.json"; exit 1; }

#       echo "Firebase Web App provisioning complete."
#     EOT
#     interpreter = ["/bin/bash", "-c"]
#   }

#   depends_on = [
#     null_resource.enable_firebase,            # from firebase.tf (AddFirebase)
#     google_project_service.required_services  # ensure APIs enabled
#   ]
# }

# ############################################################
# # Load created app + config into Terraform
# ############################################################
# data "local_file" "firebase_webapp_json" {
#   depends_on = [null_resource.firebase_webapp]
#   filename   = local.firebase_webapp_out
# }

# data "local_file" "firebase_webapp_config_json" {
#   depends_on = [null_resource.firebase_webapp]
#   filename   = local.firebase_webapp_config
# }

# ############################################################
# # Outputs (sensitive)
# ############################################################
# # Raw REST resource name: projects/PROJECT_ID/webApps/APP_ID
# output "firebase_webapp_resource_name" {
#   value     = jsondecode(data.local_file.firebase_webapp_json.content).name
#   sensitive = false
# }

# # Web App ID portion only (strip prefix)
# output "firebase_webapp_id" {
#   value = replace(
#     jsondecode(data.local_file.firebase_webapp_json.content).name,
#     "projects/${var.project_id}/webApps/",
#     ""
#   )
#   sensitive = false
# }

# # Full config JSON (apiKey, authDomain, etc.)
# output "firebase_webapp_config" {
#   value     = data.local_file.firebase_webapp_config_json.content
#   sensitive = true
# }

# # Parsed apiKey (convenience)
# output "firebase_web_api_key" {
#   value     = jsondecode(data.local_file.firebase_webapp_config_json.content).apiKey
#   sensitive = true
# }