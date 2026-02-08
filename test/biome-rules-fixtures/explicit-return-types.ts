// Should trigger: no-explicit-return-function, no-explicit-return-arrow
function withReturnType(a: number): number {
  return a;
}

const arrowWithReturnType = (x: number): number => x;

export { withReturnType, arrowWithReturnType };
