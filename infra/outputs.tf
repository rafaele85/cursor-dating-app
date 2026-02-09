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
