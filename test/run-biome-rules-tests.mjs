/**
 * Validates that custom Biome GritQL rules fire on fixture files.
 * Run: node test/run-biome-rules-tests.mjs
 * Uses: biome check test/biome-rules-fixtures --reporter=json
 */
import { spawn } from 'node:child_process';

const FIXTURES_DIR = 'test/biome-rules-fixtures';

// Plugin diagnostic messages we expect from the fixtures (at least these).
const EXPECTED_PLUGIN_MESSAGES = [
  'Explicit function return types are not allowed.',
  'Do not import from dist.',
];

// Optional: messages that may appear if more Grit patterns match (documented for future expansion).
const OPTIONAL_PLUGIN_MESSAGES = [
  'Default parameters are not allowed. Use explicit arguments or an options object.',
  'Return only a constant or variable, not an expression.',
  'Prefer type alias over interface.',
];

function runBiomeCheck() {
  return new Promise((resolve, reject) => {
    const child = spawn(
      'npx',
      ['biome', 'check', FIXTURES_DIR, '--reporter=json'],
      { cwd: process.cwd(), shell: true },
    );
    let stderr = '';
    let stdout = '';
    child.stderr.on('data', (d) => {
      stderr += d.toString();
    });
    child.stdout.on('data', (d) => {
      stdout += d.toString();
    });
    child.on('close', (code) => resolve({ code, stdout, stderr }));
  });
}

function extractJson(stdout, stderr) {
  const combined = stdout + stderr;
  const match = combined.match(/\{"summary":\s*\{/);
  if (!match) return null;
  const start = combined.indexOf(match[0]);
  let depth = 0;
  let end = start;
  for (let i = start; i < combined.length; i++) {
    if (combined[i] === '{') depth++;
    if (combined[i] === '}') {
      depth--;
      if (depth === 0) {
        end = i + 1;
        break;
      }
    }
  }
  try {
    return JSON.parse(combined.slice(start, end));
  } catch {
    return null;
  }
}

async function main() {
  const { code, stdout, stderr } = await runBiomeCheck();
  const out = extractJson(stdout, stderr);
  if (!out || !out.diagnostics) {
    console.error(
      'Could not parse Biome JSON output. stdout:',
      stdout.slice(0, 500),
    );
    console.error('stderr:', stderr.slice(0, 500));
    process.exit(1);
  }

  const pluginDiagnostics = (out.diagnostics || []).filter(
    (d) => d.category === 'plugin',
  );
  const messages = pluginDiagnostics.map((d) => d.description || '');

  const missing = EXPECTED_PLUGIN_MESSAGES.filter(
    (msg) => !messages.some((m) => m.includes(msg) || msg.includes(m)),
  );
  if (missing.length > 0) {
    console.error('Expected plugin diagnostics not found:', missing);
    console.error('Actual plugin messages:', messages);
    process.exit(1);
  }

  console.log(
    `OK: ${pluginDiagnostics.length} plugin diagnostic(s); expected messages present:`,
    EXPECTED_PLUGIN_MESSAGES.join(', '),
  );
  process.exit(0);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
