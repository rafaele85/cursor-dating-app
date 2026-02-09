provider "google" {
  project = var.project_id
  region  = var.region
}

# APIs required for Cloud Run (SCRUM-55). Enable before creating the service.
resource "google_project_service" "run" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
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

# Private services access for Cloud SQL private IP (SCRUM-53)
resource "google_compute_global_address" "private_sql" {
  name          = "dating-app-sql-private-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
  project       = var.project_id
}

resource "google_service_networking_connection" "private_sql" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_sql.name]
}

# Cloud SQL Postgres instance, private IP only (SCRUM-53)
resource "google_sql_database_instance" "main" {
  name             = var.db_instance_name
  database_version = "POSTGRES_15"
  region           = var.region
  project          = var.project_id
  deletion_protection = false

  depends_on = [google_service_networking_connection.private_sql]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.main.id
      enable_private_path_for_google_cloud_services = true
    }
  }
}

resource "google_sql_database" "main" {
  name     = var.db_name
  instance = google_sql_database_instance.main.name
  project  = var.project_id
}

resource "google_sql_user" "app" {
  name     = var.db_user
  instance = google_sql_database_instance.main.name
  password = var.db_password
  project  = var.project_id
}

# App service account for Cloud Run / Compute (SCRUM-54). Least privilege: Cloud SQL Client only.
resource "google_service_account" "app" {
  account_id   = var.app_service_account_id
  display_name = "Dating app runtime (Cloud Run / Compute)"
  project      = var.project_id
}

resource "google_project_iam_member" "app_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.app.email}"
}

# Terraform/CI service account (SCRUM-54). Used by CI to run terraform plan/apply. Least-privilege roles for current resources.
resource "google_service_account" "terraform_ci" {
  account_id   = var.terraform_ci_service_account_id
  display_name = "Terraform CI (plan/apply)"
  project      = var.project_id
}

resource "google_project_iam_member" "terraform_ci_network_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# roles/servicenetworking.networkAdmin is not supported at project level (400). Service networking
# connection may require org-level role or initial apply with user credentials; compute.networkAdmin covers VPC/subnet.
resource "google_project_iam_member" "terraform_ci_cloudsql_admin" {
  project = var.project_id
  role    = "roles/cloudsql.admin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

resource "google_project_iam_member" "terraform_ci_sa_admin" {
  project = var.project_id
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

resource "google_project_iam_member" "terraform_ci_project_iam_admin" {
  project = var.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

resource "google_project_iam_member" "terraform_ci_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# App SA needs Network User on subnet for Cloud Run direct VPC egress (SCRUM-55).
resource "google_compute_subnetwork_iam_member" "app_network_user" {
  subnetwork = google_compute_subnetwork.main.name
  region     = var.region
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${google_service_account.app.email}"
}

# Minimal Cloud Run service (SCRUM-55). Placeholder image; replace with API image when deploying.
# Direct VPC egress + Cloud SQL socket for private IP access.
resource "google_cloud_run_v2_service" "api" {
  name             = var.cloud_run_service_name
  location         = var.region
  project          = var.project_id
  deletion_protection = false
  ingress          = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.app.email
    scaling {
      min_instance_count = 0
      max_instance_count = 10
    }
    vpc_access {
      network_interfaces {
        network    = google_compute_network.main.name
        subnetwork = google_compute_subnetwork.main.name
      }
    }
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.main.connection_name]
      }
    }
    containers {
      image = var.cloud_run_image
      ports {
        container_port = 8080
      }
      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
    }
  }

  depends_on = [google_compute_subnetwork_iam_member.app_network_user, google_project_service.run]
}
