# Tickets – JIRA (Atlassian MCP)

Tickets are created and managed in **JIRA** using the **built-in Atlassian MCP** in Cursor. The agent uses the MCP to create tickets and update their status.

## Agent behaviour
- **Create tickets:** Use Atlassian MCP to create the backlog (T1–T15 below) in your JIRA project.
- **When starting work:** Move the ticket to **In Progress** via MCP.
- **When increment is done / PR opened:** Move to **Done** (or **In Review**) via MCP.
- Branch and PR titles reference the JIRA key (e.g. `PROJ-123`).

## Backlog (JIRA project: SCRUM)

| ID  | JIRA Key   | Title                              | Deps  |
|-----|------------|------------------------------------|-------|
| T1  | SCRUM-5    | Monorepo: pnpm, Biome, TS          | -     |
| ↳ T1a | SCRUM-20 | pnpm workspace (workspace.yaml + root package.json) | - |
| ↳ T1b | SCRUM-21 | TypeScript base config (tsconfig.base.json) | - |
| ↳ T1c | SCRUM-22 | Biome (biome.json + lint/format scripts) | T1a |
| T2  | SCRUM-14   | Quality gates: lint, typecheck, test | T1  |
| T3  | SCRUM-7    | API skeleton (Fastify, health)     | T1    |
| T4  | SCRUM-8    | Prisma schema + migrations         | T1    |
| T5  | SCRUM-12   | E2E setup (Playwright)             | T2    |
| T6  | SCRUM-13   | Google OAuth (client + API)        | T3, T4 |
| T7  | SCRUM-11   | Profile CRUD + auth middleware     | T6   |
| T8  | SCRUM-6    | React app shell + auth routes      | T6   |
| T9  | SCRUM-10   | Profile page                       | T7, T8 |
| T10 | SCRUM-9    | Photos: GCS + API + UI             | T4, T9 |
| T11 | SCRUM-15   | Discovery feed API                 | T4, T7 |
| T12 | SCRUM-16   | Swipe API + browse UI              | T11, T8 |
| T13 | SCRUM-17   | Matches API + list UI              | T12  |
| T14 | SCRUM-18   | Chat API + UI                      | T13  |
| T15 | SCRUM-19   | GCP deploy                         | T10, T14 |

Process: one ticket → branch → code → tests → PR → review → merge. Use Atlassian MCP to update JIRA status at each step.

---

## T1 subtasks (for review)

Each subtask is one small increment. Approve each before implementation.

| #   | JIRA Key  | Task | Deliverable |
|-----|-----------|------|-------------|
| **1** | **SCRUM-20** | **T1a: pnpm workspace** | `pnpm-workspace.yaml` (e.g. `packages: ["apps/*"]`). Root `package.json` with `private: true`, optional `scripts` (e.g. `"lint": "pnpm -r run lint"`). No app packages yet. |
| **2** | **SCRUM-21** | **T1b: TypeScript base config** | Single `tsconfig.base.json` at repo root: `target`, `module`, `strict`, `skipLibCheck`, etc. No packages yet. |
| **3** | **SCRUM-22** | **T1c: Biome** | `biome.json` (formatter + linter). In root `package.json`: add Biome devDependency and scripts `lint` / `format` (or `lint:fix`). Deps: T1a (root package.json exists). |

Review order: T1a → T1b → T1c. After all approved, implement in that order, one PR per subtask (or one PR for T1 with three commits).
