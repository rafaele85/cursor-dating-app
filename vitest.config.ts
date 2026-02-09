import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: false,
    environment: 'node',
    include: ['src/**/*.test.ts', 'test/unit/**/*.test.ts'],
    exclude: ['node_modules', 'dist', '**/biome-rules-fixtures/**'],
  },
  coverage: {
    provider: 'v8',
    include: ['src/**/*.ts'],
    exclude: [
      '**/*.test.ts',
      '**/test/**',
      'node_modules',
      'dist',
      '**/*.d.ts',
    ],
    reportsDirectory: './coverage',
    reporter: ['text', 'html'],
    thresholds: {
      lines: 80,
      functions: 80,
      branches: 80,
      statements: 80,
    },
  },
});
