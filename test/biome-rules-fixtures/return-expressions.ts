// Should trigger: no-return-call, no-return-binary
function getSum(a: number, b: number) {
  return a + b;
}

function getGreeting() {
  return getSum(1, 2);
}

export { getSum, getGreeting };
