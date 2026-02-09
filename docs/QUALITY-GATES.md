# Quality gates (SCRUM-14)

Single reference for rules from **SCRUM-30** (Biome), **SCRUM-31** (additional tools), and **SCRUM-32** (remaining lint rules).  
**Commands:**  
- **All linters:** `npm run lint:all` (lint + lint:duplication + lint:unused-exports)  
- **All unit tests:** `npm run test:all` or `npm run test` (test:biome-rules + test:unit)  
- **All quality gates:** `npm run quality-gates` (lint:all + typecheck + test:all)  
- **Coverage (SCRUM-41):** `npm run test:coverage` — runs unit tests with V8 coverage and enforces 80% threshold (lines, functions, branches, statements). Report in `./coverage`.
- Individual: `npm run lint` | `npm run lint:fix` | `npm run lint:duplication` | `npm run lint:unused-exports` | `npm run typecheck` | `npm run format` | `npm run test:biome-rules` | `npm run test:unit` | `npm run test:coverage`

**Web app (SCRUM-6):** `apps/web` — run with `npm run dev -w web` (or `cd apps/web && npm run dev`). Build: `npm run build -w web`. All quality gates run on web: root `lint` / `lint:duplication` / `lint:unused-exports` include `apps/web`; `typecheck:apps` and `test --workspaces` run web's typecheck and tests. Run full gates from root: `npm run quality-gates`.

**Lint scope:** `lint` checks `src`, the test runner, and root config files only (not `test/biome-rules-fixtures`, which exist to trigger custom rules and are validated by `test:biome-rules`).

| Rule | IsDone | Tool | Tool setting |
|------|--------|------|--------------|
| Single quotes | Y | biome | `javascript.formatter.quoteStyle: "single"` |
| Semicolons required | Y | biome | `javascript.formatter.semicolons: "always"` |
| 2-space indentation | Y | biome | `formatter.indentWidth: 2`, `formatter.indentStyle: "space"` |
| Trailing commas (multiline) | Y | biome | `javascript.formatter.trailingCommas: "all"` |
| Line endings LF | Y | biome + .gitattributes | `formatter.lineEnding: "lf"` |
| noConsole | Y | biome | `suspicious.noConsole: "warn"` |
| useConst | Y | biome | recommended |
| noVar | Y | biome | recommended |
| noDoubleEquals | Y | biome | recommended |
| noUnusedVariables | Y | biome | recommended |
| noUnusedFunctionParameters | Y | biome | recommended |
| noUnusedImports | Y | biome | recommended |
| noDefaultExport | Y | biome | `style.noDefaultExport: "error"` |
| useBlockStatements | Y | biome | recommended |
| noExplicitAny | Y | biome | recommended |
| noImplicitAnyLet | Y | biome | recommended |
| noFallthroughSwitchClause | Y | biome | recommended |
| useArrowFunction | Y | biome | recommended |
| noEmptyBlockStatements | Y | biome | recommended |
| noYodaExpression | Y | biome | recommended |
| noDebugger | Y | biome | recommended |
| noAssignInExpressions | Y | biome | recommended |
| noConstantCondition | Y | biome | recommended |
| noCompareNegZero | Y | biome | recommended |
| noClassAssign | Y | biome | recommended |
| noDuplicateCase | Y | biome | recommended |
| noPrototypeBuiltins | Y | biome | recommended |
| noUselessLoneBlockStatements | Y | biome | recommended |
| noSwitchDeclarations | Y | biome | recommended |
| useLiteralKeys | Y | biome | recommended |
| useTemplate | Y | biome | recommended |
| noNonNullAssertion | Y | biome | recommended |
| noProcessEnv | Y | biome | `style.noProcessEnv: "warn"` |
| noExcessiveCognitiveComplexity (10) | Y | biome | `complexity.noExcessiveCognitiveComplexity`, `maxAllowedComplexity: 10` |
| useStrictMode | Y | biome | `suspicious.useStrictMode: "error"` |
| Cyclomatic complexity (max 10) | Y | biome | `complexity.noExcessiveCognitiveComplexity`, `maxAllowedComplexity: 10` |
| No default parameters | Y | biome | GritQL plugins `biome-rules/no-default-params-*.grit` |
| No floating promises | Y | biome | `nursery.noFloatingPromises: "error"` |
| Import: no cycle | Y | biome | `nursery.noImportCycles: "error"` |
| Import: no duplicates | Y | biome | assist `organizeImports` (merges duplicates) |
| No magic numbers (exceptions: 0, 1, -1, 2) | Y | biome | `style.noMagicNumbers: "error"` (default ignores 0,1,2,etc.) |
| No imports from dist | Y | biome | GritQL plugin `biome-rules/no-import-from-dist.grit` |
| Prefer TypeScript types over interfaces | Y | biome | GritQL plugin `biome-rules/prefer-type-over-interface.grit` |
| Max 2 function arguments (else options object) | Y | biome | `nursery.useMaxParams: { max: 2 }` |
| No expressions in return (return only constant/variable) | Y | biome | GritQL plugins `biome-rules/no-return-*.grit` |
| Forbid explicit function return types | Y | biome | GritQL plugins `biome-rules/no-explicit-return-*.grit` |
| Copy/paste (duplication) detection | Y | jscpd | `npm run lint:duplication`, `.jscpd.json` |
| Unused export detection | Y | ts-prune | `npm run lint:unused-exports` |
| Typecheck | Y | typescript | `tsc --noEmit`, `npm run typecheck` |

**CI:** Run `npm run quality-gates` (or equivalently: `lint:all`, `typecheck`, `test:all`). Workspaces: run in each app if any.

**ESLint removed.** Two rules are **WON'T DO** (not implemented): (1) No TODO/FIXME comments in code, (2) Type/interface member delimiter (commas). GritQL attempts showed they are not feasible in Biome (comment content not matchable; delimiter not exposed in AST). See `docs/JIRA-TICKET-REMAINING-QUALITY-RULES.md` and `docs/BIOME-EXTEND-ESLINT-RULES-RESEARCH.md`.
