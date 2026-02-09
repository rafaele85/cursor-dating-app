# IaC Plan: GCP infrastructure via Terraform

## Goal
Configure GCP infrastructure for the dating app (REQUIREMENTS: deploy to GCP, Cloud SQL via Prisma) using Terraform so that all resources are versioned, repeatable, and reviewable.

## Principles
- **Terraform only:** No manual GCP Console changes for core infra; all in code.
- **Remote state:** State in GCS with locking (e.g. `terraform.tfstate` in a bucket) so multiple runs and CI are safe.
- **Minimal first:** Start with one environment (e.g. dev), one project (or use existing); add staging/prod later.
- **Align with app:** Backend (Fastify) + frontend (Next.js) + Cloud SQL (Postgres) per REQUIREMENTS.

## Implementation plan (epic → tasks)

### 1. Terraform bootstrap and repo layout
- Add `infra/` (or `terraform/`) at repo root; keep app code separate.
- Use Terraform 1.x; require a minimal `required_version` in `versions.tf`.
- **Backend:** Configure GCS backend for state (bucket + optional prefix); document that the bucket may be created once manually or via a tiny bootstrap script.
- **Structure:** One directory per “layer” or environment, e.g. `infra/base/` (shared) and `infra/envs/dev/` (dev GCP project/resources), or a single `infra/` with `main.tf`, `variables.tf`, `outputs.tf` for the first slice.

### 2. GCP provider and project
- Configure `google` and optionally `google-beta` providers.
- Use a variable for GCP project ID (and region); no hardcoding.
- Assume the GCP project already exists (created manually or by org process); Terraform does not create the project itself in the first slice unless the epic explicitly includes it.

### 3. Networking (VPC)
- Create a VPC (e.g. `google_compute_network`) and subnets for the region(s) where app and DB will run.
- Private Google Access for private subnet if Cloud SQL and/or Cloud Run will use it.
- Keep it minimal: one VPC, one or two subnets; no complex peering in the first pass.

### 4. Cloud SQL (Postgres)
- Create a Cloud SQL instance (Postgres) for the app, using the VPC.
- Database name and user managed via Terraform (sensitive vars or Secret Manager later).
- Prefer private IP; ensure the chosen subnet has private access enabled.
- Output connection name / host for the app (e.g. for Prisma `DATABASE_URL`).

### 5. IAM and service accounts
- Service account(s) for the app (e.g. Cloud Run or Compute) with least privilege.
- Grant Cloud SQL client role and any other minimal permissions needed for the app to reach DB and GCP APIs.
- Optionally a separate SA for Terraform (CI) with roles to manage the resources above.

### 6. App hosting (placeholder or minimal)
- Add a minimal “app hosting” resource: e.g. Cloud Run service (or placeholder) so the app has a target to deploy to later.
- Do not implement full CI/CD in this epic; only the infra so that “deploy to GCP” has a clear target (Cloud Run + Cloud SQL).

### 7. Docs and quality
- README in `infra/` (or under `docs/`) with: how to init, plan, apply; required vars; how to create the state bucket once; link to REQUIREMENTS.
- Add `infra/**` to `.gitignore` only for local override files (e.g. `*.tfvars.local`) and state/plan artifacts; commit all `.tf` and example `.tfvars.example`.
- Optionally: add a small script or Make target for `terraform init` / `terraform plan` so developers run the same commands.

## Suggested task order (Jira)
| # | Task | Jira |
|---|------|------|
| 1 | Terraform bootstrap and repo layout | SCRUM-50 |
| 2 | GCP provider and project | SCRUM-51 |
| 3 | Networking (VPC) | SCRUM-52 |
| 4 | Cloud SQL (Postgres) | SCRUM-53 |
| 5 | IAM and service accounts | SCRUM-54 |
| 6 | App hosting (minimal) | SCRUM-55 |
| 7 | Docs and quality | SCRUM-56 |

**Epic:** SCRUM-49 – Configure GCP infrastructure via Terraform (IaC)

## Out of scope for this epic
- Full CI/CD pipelines (separate epic/ticket).
- Multi-environment (staging/prod) – can be a follow-up.
- GCP project creation by Terraform – optional later.
- Secret Manager and runtime secrets – can be added in a later task once app needs them.
