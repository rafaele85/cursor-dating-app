provider "google" {
  project = var.project_id
  region  = var.region
}

# GCP resources (VPC, Cloud SQL, etc.) will be added in later tasks (SCRUM-52 onwards).
