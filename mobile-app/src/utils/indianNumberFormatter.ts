export function indianNumberFormatter(number: string | number) {
  const [int, decimal] = number.toString().split('.');
  return `₹${int.replace(/(\d)(?=(\d\d)+\d$)/g, '$1,')}${decimal ? '.' + decimal : ''}`;
}
