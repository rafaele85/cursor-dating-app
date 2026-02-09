# Infrastructure (Terraform)

GCP infrastructure for the dating app. See [docs/IAC-GCP-TERRAFORM-PLAN.md](../docs/IAC-GCP-TERRAFORM-PLAN.md) for the full plan.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0 (or use the project-local binary below)
- Google Cloud SDK (`gcloud`) and authentication (e.g. `gcloud auth application-default login`)
- A GCP project (existing; Terraform does not create the project). Default: **cursor-dating-app2** (project number: 530699514358).

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

- **`project_id`** (optional, default: `cursor-dating-app2`) – GCP project ID. Project number: **530699514358**.
- **`region`** (optional, default: `europe-west1`) – GCP region for resources.
- **`db_user`** (required) – Cloud SQL database user name.
- **`db_password`** (required, sensitive) – Cloud SQL database user password.
- **`db_instance_name`** (optional, default: `dating-app-db`) – Cloud SQL instance name.
- **`db_name`** (optional, default: `dating_app`) – Database name (for Prisma).
- **`app_service_account_id`** (optional, default: `dating-app-runner`) – Service account ID for the app (Cloud Run / Compute). Granted `roles/cloudsql.client` only (least privilege).
- **`terraform_ci_service_account_id`** (optional, default: `terraform-ci`) – Service account ID for Terraform/CI. Granted least-privilege roles to manage VPC, Cloud SQL, service accounts, and project IAM.

**Example `.tfvars` file** (create `dev.tfvars` or similar; add to `.gitignore` if it contains sensitive values):

```hcl
project_id  = "cursor-dating-app2"
region      = "europe-west1"
db_user     = "app"
db_password = "your-secure-password"
```

## Plan and apply

After init:

```bash
# Using defaults (project_id = cursor-dating-app2, region = europe-west1)
terraform plan -var="db_user=app" -var="db_password=YOUR_PASSWORD"
terraform apply -var="db_user=app" -var="db_password=YOUR_PASSWORD"

# Using .tfvars file (recommended)
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

Or with npm scripts:

```bash
npm run terraform:plan -- -var="db_user=app" -var="db_password=YOUR_PASSWORD"
npm run terraform:apply -- -var="db_user=app" -var="db_password=YOUR_PASSWORD"
```

## Cloud SQL Auth Proxy (local dev)

The project includes `tools/cloud-sql-proxy.x64.exe` for connecting to Cloud SQL from your machine. The instance has **private IP only**, so use the proxy for local development.

1. Ensure ADC is set up: `gcloud auth application-default login`
2. From the repo root, start the proxy:

   ```powershell
   npm run db:proxy
   ```

   Or directly: `.\tools\cloud-sql-proxy.x64.exe --port 5432 --private-ip cursor-dating-app2:europe-west1:dating-app-db`

3. In `.env` (root or app directory), set `DATABASE_URL` to connect via localhost:

   ```
   DATABASE_URL="postgresql://app:YOUR_PASSWORD@127.0.0.1:5432/dating_app?sslmode=disable"
   ```

   Use the same `db_user` and `db_password` as in Terraform; replace `YOUR_PASSWORD` with the actual password. Do not commit `.env`.

## IAM and service accounts (SCRUM-54)

Terraform creates two service accounts:

1. **App service account** (default ID: `dating-app-runner`) – **Cloud SQL Client** only. Use for Cloud Run or Compute so the app can connect to Cloud SQL. Output: `app_service_account_email` (use as Cloud Run `service_account` in SCRUM-55).

2. **Terraform/CI service account** (default ID: `terraform-ci`) – For running `terraform plan`/`apply` in CI. Least-privilege roles: `compute.networkAdmin`, `cloudsql.admin`, `iam.serviceAccountAdmin`, `resourcemanager.projectIamAdmin`. (Note: `servicenetworking.networkAdmin` is not supported at project level; creating the service networking connection may require the first apply to run with user credentials, or an org-level role.)

**Using the Terraform SA in CI:** Authenticate as this SA in your pipeline (e.g. GitHub Actions, GitLab CI) via **Workload Identity Federation** (recommended, no key file) or a **service account key** (e.g. `gcloud auth activate-service-account --key-file=...`). Store the key or federation config as a CI secret; do not commit keys. The first `terraform apply` that creates this SA must be run with credentials that can create service accounts and set IAM (e.g. your user or an org admin).

## Layout

- `versions.tf` – Terraform version constraint and GCS backend (partial; bucket/prefix via `-backend-config`).
- `main.tf` – Main resource definitions (filled in by SCRUM-51+).
- `variables.tf` – Input variables (filled in by SCRUM-51+).
- `outputs.tf` – Output values (filled in by later tasks).
