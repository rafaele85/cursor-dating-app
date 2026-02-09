provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC and subnet for app/DB (SCRUM-52). Private Google Access enabled for Cloud SQL/Cloud Run.
resource "google_compute_network" "main" {
  name                    = "dating-app-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "main" {
  name                     = "dating-app-subnet"
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.main.id
  private_ip_google_access = true
  project                  = var.project_id
}
