variable "project_id" {
  description = "GCP project ID (existing project)"
  type        = string
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
