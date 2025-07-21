variable "project_id" {
  description = "Unique project ID for GCP"
  type        = string
}

variable "region" {
  description = "GCP region"
  default     = "asia-south1"
}

# variable "billing_account_id" {
#   description = "Billing account ID (can be fetched via gcloud)"
#   type        = string
# }

# variable "org_id" {
#   description = "Organization ID (optional if you're using personal account)"
#   type        = string
# }
variable "developer_email" {
  description = "Developer email for IAM binding"
  type        = string
}