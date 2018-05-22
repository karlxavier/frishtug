const ONE_CENT = 100

const $cents = (number) => {
  const num = isNaN(number) ? 0 : number
  return Math.round(num * ONE_CENT)
}

const $dollar = (cents) => {
  const num = isNaN(cents) ? 0 : cents
  return Number((num / ONE_CENT).toFixed(2))
}

const $tax = (number, tax) => {
  return Math.round(number * tax)
}

module.exports = {
  $cents: $cents,
  $dollar: $dollar,
  $tax: $tax
}