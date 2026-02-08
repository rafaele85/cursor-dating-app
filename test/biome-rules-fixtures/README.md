# Fixtures for custom Biome GritQL rules

These TypeScript files are intended to **trigger** the custom GritQL plugins under `biome-rules/`. The test runner `run-biome-rules-tests.mjs` runs `biome check` on this directory with `--reporter=json` and asserts that expected plugin diagnostics are present.

## Fixture files

| File | Intended rule(s) |
|------|-------------------|
| `default-params.ts` | No default parameters (function + arrow) |
| `return-expressions.ts` | No expressions in return (call, binary) |
| `explicit-return-types.ts` | No explicit function return types |
| `interface.ts` | Prefer type over interface |
| `import-from-dist.ts` | No imports from dist |

## Running the tests

From the repo root:

```bash
npm run test:biome-rules
```

Or:

```bash
node test/run-biome-rules-tests.mjs
```

## Note

Biome format is disabled for this directory via `biome.json` overrides so that test assertions focus on plugin (GritQL) diagnostics only.
