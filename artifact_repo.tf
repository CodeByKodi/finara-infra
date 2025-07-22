resource "google_artifact_registry_repository" "finara_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = "finara-repo"
  description   = "Artifact Registry for Finara agent container"
  format        = "DOCKER"

  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }

  cleanup_policies {
    action = "DELETE"
    condition {
      older_than = "30d"
    }
  }
}