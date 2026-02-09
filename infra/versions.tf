terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  # GCS backend - uncomment and configure when bucket is created
  # For now, using default local backend for testing
  # backend "gcs" {
  #   # bucket and prefix supplied via -backend-config or .tfbackend file
  #   # e.g. terraform init -backend-config="bucket=YOUR_BUCKET" -backend-config="prefix=terraform/state"
  # }
}
