const eslint = require('@eslint/js');
const tseslint = require('typescript-eslint');
const stylisticTs = require('@stylistic/eslint-plugin-ts');
const promise = require('eslint-plugin-promise');
const importPlugin = require('eslint-plugin-import');

module.exports = tseslint.config(
  { ignores: ['node_modules', 'dist', '.next', 'coverage', '**/*.min.js'] },
  eslint.configs.recommended,
  ...tseslint.configs.recommended,
  {
    files: ['**/*.ts', '**/*.tsx'],
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: __dirname,
      },
    },
    plugins: {
      '@stylistic/ts': stylisticTs,
      promise,
      import: importPlugin,
    },
    rules: {
      // SCRUM-31: Cyclomatic complexity threshold 10
      complexity: ['error', { max: 10 }],
      // Type/interface: commas not semicolons
      '@stylistic/ts/member-delimiter-style': [
        'error',
        {
          multiline: { delimiter: 'comma', requireLast: true },
          singleline: { delimiter: 'comma', requireLast: false },
        },
      ],
      // No default parameters
      'no-restricted-syntax': [
        'error',
        {
          selector:
            'FunctionDeclaration > FormalParameters > AssignmentPattern, FunctionExpression > FormalParameters > AssignmentPattern, ArrowFunctionExpression > FormalParameters > AssignmentPattern',
          message:
            'Default parameters are not allowed. Use explicit arguments or an options object.',
        },
      ],
      // Floating promises
      '@typescript-eslint/no-floating-promises': 'error',
      // Promise/import-style: selected rules
      'promise/no-new-statics': 'error',
      'promise/valid-params': 'error',
      'import/no-duplicates': 'error',
      'import/no-cycle': ['error', { maxDepth: 1 }],
    },
    settings: {
      'import/resolver': {
        typescript: {},
        node: true,
      },
    },
  },
);
