terraform {
  backend "gcs" {
    bucket  = "geni-bucket"
    prefix  = "env/default"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}