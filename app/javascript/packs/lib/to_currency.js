const toCurrency = (number) => {
  return parseFloat(number).toLocaleString('en-US', {
    style: 'currency',
    currency: 'USD'
  })
}

module.exports = toCurrency
