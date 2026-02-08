# Quality gates (SCRUM-14)

Single reference for rules from **SCRUM-30** (Biome) and **SCRUM-31** (additional tools).  
**Commands:** `npm run lint` | `npm run lint:fix` | `npm run lint:eslint` | `npm run lint:duplication` | `npm run lint:unused-exports` | `npm run typecheck` | `npm run format`

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
| noProcessEnv | Y | biome | `nursery.noProcessEnv: "warn"` |
| noExcessiveCognitiveComplexity (15) | Y | biome | `complexity.noExcessiveCognitiveComplexity`, `maxAllowedComplexity: 15` |
| useStrictMode | Y | biome | `nursery.useStrictMode: "error"` |
| Explicit return types (forbid) | Y | biome | useExplicitType not enabled |
| Cyclomatic complexity (max 10) | Y | eslint | `complexity: ["error", { max: 10 }]` |
| Type/interface member delimiter (commas) | Y | eslint | `@stylistic/ts/member-delimiter-style` |
| No default parameters | Y | eslint | `no-restricted-syntax` (AssignmentPattern in FormalParameters) |
| No floating promises | Y | eslint | `@typescript-eslint/no-floating-promises` |
| Promise: no-new-statics | Y | eslint | `promise/no-new-statics` |
| Promise: valid-params | Y | eslint | `promise/valid-params` |
| Import: no duplicates | Y | eslint | `import/no-duplicates` |
| Import: no cycle | Y | eslint | `import/no-cycle` |
| Copy/paste (duplication) detection | Y | jscpd | `npm run lint:duplication`, `.jscpd.json` |
| Unused export detection | Y | ts-prune | `npm run lint:unused-exports` |
| Typecheck | Y | typescript | `tsc --noEmit`, `npm run typecheck` |
| No magic numbers (exceptions: 0, 1, -1, 2) | N | — | SCRUM-32 |
| No TODO comments in code (TODOs in TODO.md) | N | — | SCRUM-32 |
| No imports from dist | N | — | SCRUM-32 |
| Prefer TypeScript types over interfaces | N | — | SCRUM-32 |
| Max 2 function arguments (else options object) | N | — | SCRUM-32 |
| No expressions in return (return only constant/variable) | N | — | SCRUM-32 |
| Forbid explicit function return types | N | — | SCRUM-32 |

**CI:** Run `lint`, `typecheck`, `lint:eslint`, `lint:duplication`, `lint:unused-exports`, `test`.
