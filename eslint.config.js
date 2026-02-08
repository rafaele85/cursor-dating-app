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
        // SCRUM-32: No expressions in return (return only constant or variable)
        {
          selector:
            'ReturnStatement[argument.type="CallExpression"], ReturnStatement[argument.type="BinaryExpression"], ReturnStatement[argument.type="LogicalExpression"], ReturnStatement[argument.type="ConditionalExpression"], ReturnStatement[argument.type="ObjectExpression"], ReturnStatement[argument.type="ArrayExpression"], ReturnStatement[argument.type="UnaryExpression"]',
          message: 'Return only a constant or variable, not an expression.',
        },
        // SCRUM-32: Forbid explicit function return types
        {
          selector:
            'FunctionDeclaration[returnType], ArrowFunctionExpression[returnType], FunctionExpression[returnType]',
          message: 'Explicit function return types are not allowed.',
        },
      ],
      // Floating promises
      '@typescript-eslint/no-floating-promises': 'error',
      // Promise/import-style: selected rules
      'promise/no-new-statics': 'error',
      'promise/valid-params': 'error',
      'import/no-duplicates': 'error',
      'import/no-cycle': ['error', { maxDepth: 1 }],
      // SCRUM-32: No magic numbers (exceptions: 0, 1, -1, 2)
      'no-magic-numbers': 'off',
      '@typescript-eslint/no-magic-numbers': [
        'error',
        { ignore: [0, 1, -1, 2], ignoreArrayIndexes: true },
      ],
      // SCRUM-32: No TODO/FIXME in source (use TODO.md)
      'no-warning-comments': [
        'error',
        { terms: ['TODO', 'FIXME'], location: 'start' },
      ],
      // SCRUM-32: No imports from dist
      'import/no-restricted-paths': [
        'error',
        {
          zones: [
            {
              target: '.',
              from: './dist',
              message: 'Do not import from dist.',
            },
          ],
        },
      ],
      // SCRUM-32: Prefer type over interface
      '@typescript-eslint/consistent-type-definitions': ['error', 'type'],
      // SCRUM-32: Max 2 function arguments (else options object)
      'max-params': ['error', 2],
    },
    settings: {
      'import/resolver': {
        typescript: {},
        node: true,
      },
    },
  },
);
