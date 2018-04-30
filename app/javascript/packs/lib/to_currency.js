const toCurrency = (number) => {
  const num = isNaN(number) ? 0 : number
  return parseFloat(num).toLocaleString('en-US', {
    style: 'currency',
    currency: 'USD'
  })
}

module.exports = toCurrency
