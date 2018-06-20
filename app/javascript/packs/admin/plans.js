const init = () => {
  const shippingSelect = document.querySelector('.plan-shipping')
  const shippingFeeInput = document.querySelector('.plan-shipping-fee')
  const shippingNoteInput = document.querySelector('.plan-shipping-note')
  const shippingTypeInput = document.querySelector('.plan-shipping-type')

  const showAdditionalInputs = () => {
    shippingFeeInput.classList.remove('d-none')
    shippingFeeInput.classList.add('animated')
    shippingNoteInput.classList.remove('d-none')
    shippingNoteInput.classList.add('animated')
    shippingTypeInput.classList.remove('d-none')
    shippingTypeInput.classList.add('animated')
  }

  const hideAdditionalInputs = () => {
    shippingFeeInput.classList.add('d-none')
    shippingFeeInput.classList.remove('animated')
    shippingNoteInput.classList.add('d-none')
    shippingNoteInput.classList.remove('animated')
    shippingTypeInput.classList.add('d-none')
    shippingTypeInput.classList.remove('animated')
  }

  if (shippingSelect) {
    shippingSelect.addEventListener('change', (e) => {
      const isPaid = e.target.value === 'paid'
      if (isPaid) {
        showAdditionalInputs()
      } else {
        hideAdditionalInputs()
      }
    })

    if (shippingSelect.value === 'paid') {
      showAdditionalInputs()
    }
  } else {
    console.warn('[plan-shipping] class not found.')
  }
}
//
init()