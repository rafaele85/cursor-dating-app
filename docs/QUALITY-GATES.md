# Quality gates (SCRUM-14, SCRUM-31)

## Biome (SCRUM-30)

- `npm run lint` – Biome check (format + lint)
- `npm run lint:fix` – Apply Biome fixes
- `npm run format` – Format only

## TypeScript

- `npm run typecheck` – `tsc --noEmit` (root + src)

## Additional tools (SCRUM-31, non-Biome)

- **ESLint** – Rules not covered by Biome:
  - Cyclomatic complexity (max 10)
  - Type/interface member delimiter: commas
  - No default parameters
  - No floating promises
  - Promise and import best practices
- `npm run lint:eslint` – Run ESLint on `src/`

- **jscpd** – Copy/paste (duplication) detection
- `npm run lint:duplication` – Run jscpd on `src/`

- **ts-prune** – Unused export detection
- `npm run lint:unused-exports` – Run ts-prune

CI should run: `lint`, `typecheck`, `lint:eslint`, `lint:duplication`, `lint:unused-exports`, `test`.
