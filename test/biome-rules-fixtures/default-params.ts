// Should trigger: no-default-params (function and arrow)
function withDefaultFirst(a = 1, b: number) {
  return a + b;
}

const arrowWithDefault = (x = 0) => x;

export { withDefaultFirst, arrowWithDefault };
