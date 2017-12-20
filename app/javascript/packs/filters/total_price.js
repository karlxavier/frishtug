const totalPrice = (obj) => {
  const total = obj.reduce( (sum, item) => {
    return sum += parseFloat(item.price)
  }, 0)
  return total
}


module.exports = totalPrice
