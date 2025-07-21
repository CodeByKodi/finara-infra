resource "google_project_iam_member" "vertex_ai_admin" {
  project = var.project_id
  role    = "roles/aiplatform.admin"
  member  = "user:${var.developer_email}"
}

resource "google_project_iam_member" "firebase_admin" {
  project = var.project_id
  role    = "roles/firebase.admin"
  member  = "user:${var.developer_email}"
}

resource "google_project_iam_member" "functions_admin" {
  project = var.project_id
  role    = "roles/cloudfunctions.admin"
  member  = "user:${var.developer_email}"
}

resource "google_project_iam_member" "secretmanager_access" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "user:${var.developer_email}"
}