terraform {
  required_version = ">= 1.0"

  backend "gcs" {
    # bucket and prefix supplied via -backend-config or .tfbackend file
    # e.g. terraform init -backend-config="bucket=YOUR_BUCKET" -backend-config="prefix=terraform/state"
  }
}
