# Remaining quality gate rules

**JIRA:** **SCRUM-32** (created; parent SCRUM-14, sprint 1, StarTeam).  
This file is a local copy of the ticket description for reference.

**Summary:** Quality gates: remaining lint rules (magic numbers, TODO, dist imports, types vs interfaces, max args, return style, explicit return types)

**Description:**

**Scope:** Additional rules from SCRUM-31 backlog. Parent: Epic SCRUM-14. Related: SCRUM-31, SCRUM-30.

**Rules to implement:**

1. **No magic numbers** – Error on numeric literals except 0, 1, -1, 2. Option: ESLint no-magic-numbers with exceptions.
2. **No TODO comments in code** – All TODOs in TODO.md; fail on TODO/FIXME in source. Option: ESLint no-warning-comments or custom.
3. **No imports from "dist"** – Error on imports from dist. Option: eslint-plugin-import restriction or custom rule.
4. **Prefer TypeScript types over interfaces** – Enforce type aliases over interface. Option: @typescript-eslint/consistent-type-definitions.
5. **Max 2 function arguments** – Else use options object. Option: max-params or custom.
6. **No expressions in return** – Return only single constant or variable. Option: Custom rule or no-restricted-syntax.
7. **Forbid explicit function return types** – No explicit return type annotations. Option: Custom rule (opposite of useExplicitType).

**Acceptance criteria:** Each rule implemented and documented; CI runs checks; docs/QUALITY-GATES.md updated.

---

**Decision (2026-02-08):** ESLint has been removed from the project (dependencies and scripts). The following rules are **WON'T DO** and are not enforced:

1. **No TODO comments in code** – Not implemented. GritQL cannot match comment content in Biome; not feasible.
2. **Type/interface member delimiter (commas)** – Not implemented. Delimiter is trivia in the AST; GritQL cannot distinguish semicolon vs comma.

See `docs/QUALITY-GATES.md` and `docs/BIOME-EXTEND-ESLINT-RULES-RESEARCH.md`.
