variable "project_id" {
  description = "GCP project ID (existing project)"
  type        = string
}

variable "region" {
  description = "GCP region (e.g. europe-west1, us-central1)"
  type        = string
  default     = "europe-west1"
}
