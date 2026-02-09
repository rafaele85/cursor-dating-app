variable "project_id" {
  description = "GCP project ID (existing project). Project number: 530699514358."
  type        = string
  default     = "cursor-dating-app2"
}

variable "region" {
  description = "GCP region (e.g. europe-west1, us-central1)"
  type        = string
  default     = "europe-west1"
}

variable "subnet_cidr" {
  description = "CIDR for the main subnet (e.g. 10.0.1.0/24)"
  type        = string
  default     = "10.0.1.0/24"
}

# Cloud SQL (SCRUM-53)
variable "db_instance_name" {
  description = "Cloud SQL instance name (must be unique, lowercase, hyphen)"
  type        = string
  default     = "dating-app-db"
}

variable "db_name" {
  description = "Database name (for Prisma)"
  type        = string
  default     = "dating_app"
}

variable "db_user" {
  description = "Database user name"
  type        = string
}

variable "db_password" {
  description = "Database user password (sensitive)"
  type        = string
  sensitive   = true
}
