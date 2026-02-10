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

# IAM (SCRUM-54)
variable "app_service_account_id" {
  description = "Service account ID for the app (Cloud Run / Compute). Must be unique in project, lowercase, hyphen."
  type        = string
  default     = "dating-app-runner"
}

variable "terraform_ci_service_account_id" {
  description = "Service account ID for Terraform/CI (plan/apply). Must be unique in project, lowercase, hyphen."
  type        = string
  default     = "terraform-ci"
}

# Cloud Run (SCRUM-55)
variable "cloud_run_service_name" {
  description = "Cloud Run service name (API / backend). Must be unique in region, lowercase, hyphen."
  type        = string
  default     = "dating-app-api"
}

variable "cloud_run_image" {
  description = "Container image for Cloud Run service (placeholder until API image is built)."
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}
