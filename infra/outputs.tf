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
