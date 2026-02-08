# Research: Extending Biome to Cover ESLint Checks (incl. GritQL)

**Date:** 2026-02-08  
**Context:** Quality gates currently use both Biome and ESLint (SCRUM-30, SCRUM-31, SCRUM-32). This doc summarizes whether Biome can be extended to cover the checks implemented via ESLint, including custom rules with GritQL.

**Migration status (2026-02-08):** ESLint has been fully removed (dependencies and scripts). Two rules are **WON'T DO**: (1) no-warning-comments (TODO/FIXME)—comment content not matchable in GritQL; (2) member-delimiter-style—delimiter not exposed in AST. See `docs/QUALITY-GATES.md` and `docs/JIRA-TICKET-REMAINING-QUALITY-RULES.md`.

---

## Short answer

**Yes, with caveats.** Biome can be extended in two ways:

1. **Built-in rules** – Many ESLint-style rules exist in Biome (often under different names). Some are only in **Biome 2.x** (e.g. `noMagicNumbers`, `noImportCycles`). Our project uses **Biome 1.9.4**, so those are not available today without upgrading.
2. **GritQL linter plugins** – You can implement **custom lint rules** in Biome using GritQL: write a `.grit` file that matches code patterns and calls `register_diagnostic()` to report issues. Plugins are enabled in config via `"plugins": ["./path-to-plugin.grit"]`. This is the way to add rules Biome doesn’t ship (e.g. “no expressions in return”, “forbid explicit return types”).

So: **you can implement custom rules in Biome with GritQL**, and you can cover more of the current ESLint checks by either upgrading Biome to 2.x (for built-in rules) or adding GritQL plugins (for custom patterns).

---

## 1. GritQL custom rules in Biome

### What it is

- **GritQL** is a structural search/query language (by Grit.io, open-source). Biome uses it for:
  - **Linter plugins** – custom rules that report diagnostics.
  - **`biome search`** – structural code search in the CLI (and planned for IDE).

### How custom rules work

1. Create a **`.grit`** file in the repo with a GritQL snippet.
2. In that snippet you:
   - **Match** code with patterns (snippets in backticks, variables like `$fn`, conditions with `where`).
   - **Emit a diagnostic** with `register_diagnostic(span = $node, message = "...", severity = "error"|"warn"|"info"|"hint")`.
3. Enable the plugin in **biome.json** (or equivalent):

   ```json
   {
     "linter": {
       "plugins": ["./path-to-plugin.grit"]
     }
   }
   ```

   (Exact config key may depend on Biome version; docs show top-level `"plugins"` in some places.)

### Example (from Biome docs)

Report `Object.assign()` and suggest object spread:

```grit
`$fn($args)` where {
  $fn <: `Object.assign`,
  register_diagnostic(
    span = $fn,
    message = "Prefer object spread instead of `Object.assign()`"
  )
}
```

### Capabilities

- **Structural matching**: ignores whitespace, quote style, etc.
- **Variables**: e.g. `$fn`, `$method` to match any identifier or expression.
- **Conditions**: `where { $x <: `log` }` and similar.
- **Biome syntax nodes**: for precise AST matching you can use Biome’s node names (e.g. `JsIfStatement`) with `engine biome(1.0)` and `language js(typescript,jsx)`.
- **Languages**: JS/TS and CSS in current Biome GritQL support.

### Limitations (as of current docs and issue #2582)

- **No rewrites** – Patterns can report diagnostics only; automatic fixes are not applied.
- **No multifile / sequential** pattern handling (for cross-file rules).
- **No Grit pattern library** compatibility (yet).
- **Suppressions** – Grit has its own; Biome intends to align with Biome’s suppression system.
- **JS functions inside GritQL** – not supported.
- **Integration status** – Some features still in progress; see [Biome #2582](https://github.com/biomejs/biome/issues/2582) and [RFC 1762](https://github.com/biomejs/biome/discussions/1762).

So: **GritQL in Biome is well-suited for pattern-based custom rules that only need to report diagnostics**, not for auto-fixes or complex cross-file logic.

---

## 2. Covering current ESLint checks with Biome

### Our setup

- **Biome:** 1.9.4  
- **ESLint:** used for SCRUM-31 and SCRUM-32 rules (complexity, member-delimiter, no default params, floating promises, promise/import rules, then SCRUM-32: magic numbers, TODO/FIXME, no dist imports, prefer type, max params, return style, no explicit return types).

### Option A: Use more built-in Biome rules (often requires Biome 2.x)

| Check | In Biome? | Notes |
|-------|-----------|--------|
| Import cycles | Yes | **Biome 2.0+**: `nursery.noImportCycles` (replaces ESLint `import/no-cycle`). |
| Magic numbers | Yes | **Biome 2.1+**: `style.noMagicNumbers` (replaces ESLint `no-magic-numbers`). Default ignores 0,1,2, etc.; configurable. |
| Prefer type over interface | No | No direct equivalent in Biome rule list; could be implemented as a GritQL plugin (match `interface` declarations and report). |
| Max params | No | No built-in rule; could be a GritQL plugin (match function nodes and check param count). |
| No TODO/FIXME | Partial | No exact “no-warning-comments”; could be a GritQL pattern matching comment content. |
| No imports from dist | No | Could be a GritQL plugin matching import sources containing `dist`. |
| No expressions in return | No | GritQL: match `ReturnStatement` with argument that is a complex expression (e.g. CallExpression, BinaryExpression). |
| No explicit return types | No | GritQL: match function nodes that have a `returnType` (Biome AST). |

So: **several checks can move to Biome built-in rules if we upgrade to 2.x**; the rest can be approximated or implemented as **GritQL plugins**.

### Option B: GritQL plugins for rules Biome doesn’t have

Examples of what can be done with GritQL today:

- **No expressions in return** – Match `ReturnStatement` with an argument that is not a simple identifier/literal (e.g. match CallExpression, BinaryExpression under return).
- **Forbid explicit return types** – Match function declarations/expressions that have a `returnType` (using Biome’s syntax nodes).
- **Max 2 params** – Match function nodes and in a condition check param count (if GritQL supports that on the matched node).
- **Prefer type over interface** – Match `interface` declarations and call `register_diagnostic` suggesting `type` instead.
- **No imports from dist** – Match import specifiers whose source string contains `"dist"` or `'dist'`.
- **TODO/FIXME in comments** – Match comment nodes whose text contains “TODO” or “FIXME” and report.

Exact feasibility depends on the GritQL/Biome node API and which node types are exposed (see [Biome Playground](https://biomejs.dev/playground/) and [GritQL language docs](https://docs.grit.io/language/overview)).

---

## 3. Version and config note

- **Biome 1.9.4** (our current version): The published `configuration_schema.json` for the linter does **not** include a `plugins` property in `LinterConfiguration`. GritQL linter plugins may be documented for **Biome 2.x** or a later 1.x; we did not confirm the exact first version that supports `linter.plugins` or top-level `plugins`.
- **Biome 2.x** adds:
  - `noImportCycles` (nursery)
  - `noMagicNumbers` (style)
  - And likely the documented GritQL plugin configuration.

So: **to rely on both built-in rules and GritQL plugins as in the docs, upgrading to Biome 2.x is the safe bet.**

---

## 4. Recommendations

1. **Confirm plugin support in our version** – Try adding a minimal `.grit` file and `"plugins": ["./something.grit"]` (under `linter` or top-level) in `biome.json` on 1.9.4. If it’s not supported, plan an upgrade to 2.x to use GritQL plugins.
2. **Upgrade to Biome 2.x** – Unlocks `noImportCycles`, `noMagicNumbers`, and the documented plugin system, and allows dropping or reducing ESLint for those checks.
3. **Implement missing rules as GritQL plugins** – For “no expressions in return”, “no explicit return types”, “prefer type”, “no dist imports”, “max params”, “no TODO in code”, implement small `.grit` rules and enable them in Biome so one tool runs all checks where possible.
4. **Keep ESLint only where necessary** – e.g. type-aware or plugin-specific rules that Biome + GritQL cannot replicate (e.g. some `@typescript-eslint` rules that need full type information). Document which checks remain in ESLint and why.

---

## 5. References

- [Biome – GritQL](https://biomejs.dev/reference/gritql/)
- [Biome – Linter Plugins](https://biomejs.dev/linter/plugins/)
- [Biome – noMagicNumbers](https://biomejs.dev/linter/rules/no-magic-numbers/) (v2.1+)
- [Biome – noImportCycles](https://biomejs.dev/linter/rules/no-import-cycles/) (v2.0+)
- [Biome #2582 – GritQL engine bindings](https://github.com/biomejs/biome/issues/2582)
- [Biome RFC 1762 – Plugin direction](https://github.com/biomejs/biome/discussions/1762)
- [GritQL language overview](https://docs.grit.io/language/overview)
