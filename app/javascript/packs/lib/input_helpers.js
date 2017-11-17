const $is_not_text = (input) => {
  return input.tagName !== 'INPUT' && input.type !== 'text'
}

const $is_not_select = (input) => {
  return input.tagName !== 'SELECT'
}

const $only_numbers = (input) => {
  if ($is_not_text(input)) { return false }
  return input.value = input.value.replace(/[^\d+]/g, '')
}

const $limit = (input, limit) => {
  if ($is_not_text(input)) { return false }
  return input.value = input.value.substring(0, limit)
}

// Valid formats are
// (123) 456-7890
// (123)456-7890
// 123-456-7890
// 123.456.7890
// 1234567890
// +31313131313
// 075-12345678
const $US_phone_only = (input) => {
  const regEx = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/im
  return regEx.test(input.value)
}

module.exports = {
  $limit: $limit,
  $only_numbers: $only_numbers,
  $is_not_text: $is_not_text,
  $is_not_select: $is_not_select,
  $US_phone_only: $US_phone_only
}