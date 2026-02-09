# Infrastructure (Terraform)

GCP infrastructure for the dating app. See [docs/IAC-GCP-TERRAFORM-PLAN.md](../docs/IAC-GCP-TERRAFORM-PLAN.md) for the full plan.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0 (or use the project-local binary below)
- Google Cloud SDK (`gcloud`) and authentication (e.g. `gcloud auth application-default login`)
- A GCP project (existing; Terraform does not create the project)

### Project-local Terraform

This repo includes `tools/terraform.exe` (Windows). From the repo root:

```bash
# Windows (PowerShell or cmd)
.\tools\terraform.exe -chdir=infra init -backend-config="bucket=YOUR_BUCKET" -backend-config="prefix=terraform/state"
.\tools\terraform.exe -chdir=infra plan
```

Or from inside `infra/`:

```bash
cd infra
..\tools\terraform.exe init -backend-config="bucket=YOUR_BUCKET" -backend-config="prefix=terraform/state"
..\tools\terraform.exe plan
```

**npm scripts (from repo root):** `npm run terraform:init`, `npm run terraform:validate`, `npm run terraform:plan`, `npm run terraform:apply`. Pass backend config to init with `--`, e.g. `npm run terraform:init -- -backend-config="bucket=YOUR_BUCKET" -backend-config="prefix=terraform/state"`.

## State bucket (one-time setup)

Terraform state is stored in a **GCS bucket**. Create the bucket once before the first `terraform init`:

1. Choose a globally unique bucket name (e.g. `your-org-dating-app-tfstate`).
2. Create the bucket and enable versioning (recommended for state recovery):

   ```bash
   gcloud storage buckets create gs://YOUR_BUCKET_NAME --location=EU
   gcloud storage buckets update gs://YOUR_BUCKET_NAME --versioning
   ```

3. Use the same bucket name when initializing the backend (see below).

## Initialization

From the `infra/` directory:

```bash
cd infra
terraform init -backend-config="bucket=YOUR_BUCKET_NAME" -backend-config="prefix=terraform/state"
```

Replace `YOUR_BUCKET_NAME` with the GCS bucket you created. The `prefix` is the path prefix for the state object inside the bucket (default shown above).

Alternatively, use a backend config file (do not commit secrets):

```bash
# backend.gcs.tfbackend (example; add to .gitignore if it contains env-specific names)
bucket = "YOUR_BUCKET_NAME"
prefix = "terraform/state"
```

Then:

```bash
terraform init -backend-config=backend.gcs.tfbackend
```

## Variables

Required variables (set via `-var`, `-var-file`, or `.tfvars`):

- **`project_id`** (required) – Your GCP project ID (e.g. `my-dating-app-123456`).
- **`region`** (optional, default: `europe-west1`) – GCP region for resources.

**Example `.tfvars` file** (create `dev.tfvars` or similar; add to `.gitignore` if it contains sensitive values):

```hcl
project_id = "your-gcp-project-id"
region     = "europe-west1"
```

## Plan and apply

After init:

```bash
# Using -var
terraform plan -var="project_id=YOUR_PROJECT_ID" -var="region=europe-west1"
terraform apply -var="project_id=YOUR_PROJECT_ID" -var="region=europe-west1"

# Using .tfvars file (recommended)
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

Or with npm scripts:

```bash
npm run terraform:plan -- -var="project_id=YOUR_PROJECT_ID"
npm run terraform:apply -- -var="project_id=YOUR_PROJECT_ID"
```

## Layout

- `versions.tf` – Terraform version constraint and GCS backend (partial; bucket/prefix via `-backend-config`).
- `main.tf` – Main resource definitions (filled in by SCRUM-51+).
- `variables.tf` – Input variables (filled in by SCRUM-51+).
- `outputs.tf` – Output values (filled in by later tasks).
