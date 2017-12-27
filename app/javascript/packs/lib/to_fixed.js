const toFixed = (num, fixed) => {
  const re = new RegExp('^-?\\d+(?:\.\\d{0,' + (fixed || -1) + '})?')
  return parseFloat(num.toString().match(re)[0])
}


module.exports = toFixed
