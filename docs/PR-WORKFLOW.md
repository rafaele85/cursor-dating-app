# PR workflow

- Work happens on **feature branches**, not directly on `main`/`master`.
- Open a **PR** for human review; merge after approval.
- Branch names: include JIRA key when applicable (e.g. `docs/SCRUM-20-t1-subtasks` or `feat/SCRUM-5-monorepo`).

## Current PR (ready to open)

**Branch:** `docs/t1-subtasks`  
**Base:** `master`  
**Title:** `docs: T1 split into subtasks (SCRUM-20,21,22)`  
**Summary:** Updates TICKETS.md with T1 split into subtasks SCRUM-20 (T1a pnpm), SCRUM-21 (T1b TS config), SCRUM-22 (T1c Biome). Adds "T1 subtasks (for review)" section.

**To create the PR after adding a remote:**

```bash
git remote add origin <your-repo-url>
git push -u origin docs/t1-subtasks
# Then: open PR in GitHub/GitLab (base: master, compare: docs/t1-subtasks)
# Or with GitHub CLI: gh pr create --base master --head docs/t1-subtasks --title "docs: T1 split into subtasks (SCRUM-20,21,22)" --body "See docs/TICKETS.md. For review."
```
