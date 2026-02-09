output "network_name" {
  description = "VPC network name"
  value       = google_compute_network.main.name
}

output "subnet_name" {
  description = "Subnet name (for Cloud SQL, Cloud Run)"
  value       = google_compute_subnetwork.main.name
}

output "subnet_self_link" {
  description = "Subnet self link for referencing in other resources"
  value       = google_compute_subnetwork.main.self_link
}

# Cloud SQL (SCRUM-53) - for Prisma DATABASE_URL
output "db_connection_name" {
  description = "Cloud SQL connection name (project:region:instance) for Cloud SQL Auth Proxy"
  value       = google_sql_database_instance.main.connection_name
}

output "db_private_ip" {
  description = "Cloud SQL private IP (for DATABASE_URL when in VPC)"
  value       = google_sql_database_instance.main.private_ip_address
}

output "db_name" {
  description = "Database name"
  value       = google_sql_database.main.name
}

# IAM (SCRUM-54) - for Cloud Run service_account or Compute
output "app_service_account_email" {
  description = "App service account email (use as Cloud Run service_account or Compute SA)"
  value       = google_service_account.app.email
}

output "terraform_ci_service_account_email" {
  description = "Terraform/CI service account email (use in CI for terraform plan/apply; e.g. Workload Identity or key)"
  value       = google_service_account.terraform_ci.email
}
