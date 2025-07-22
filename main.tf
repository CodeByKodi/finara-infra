provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "required_services" {
  for_each = toset([
    "compute.googleapis.com",
    "dataflow.googleapis.com",
    "notebooks.googleapis.com",
    "aiplatform.googleapis.com",              # Vertex AI
    "generativelanguage.googleapis.com",      # Gemini API
    "firebase.googleapis.com",                # Firebase
    "firestore.googleapis.com",               # Firestore DB
    "cloudfunctions.googleapis.com",          # Cloud Functions
    "iam.googleapis.com",                     # IAM roles and service accounts
    "cloudbuild.googleapis.com",              # Build triggers
    "artifactregistry.googleapis.com",        # Container Registry
    "monitoring.googleapis.com",              # Cloud Monitoring
    "logging.googleapis.com",                 # Cloud Logging
    "secretmanager.googleapis.com",           # Secret Management
  ])
  project             = var.project_id
  service             = each.key
  disable_on_destroy  = false
}