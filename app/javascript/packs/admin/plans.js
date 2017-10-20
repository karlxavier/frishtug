document.addEventListener('DOMContentLoaded', ()=>{
  (function(win) {
    const init = () => {
      const shippingSelect = document.querySelector('.plan-shipping')
      const shippingFeeInput = document.querySelector('.plan-shipping-fee')
      if (shippingSelect) {
        shippingSelect.addEventListener('change', (e) => {
          const isPaid = e.target.value === '1'
          if (isPaid) {
            shippingFeeInput.classList.remove('d-none')
            shippingFeeInput.classList.add('animated')
          } else {
            shippingFeeInput.classList.add('d-none')
            shippingFeeInput.classList.remove('animated')
          }
        })
      } else {
        console.warn('[plan-shipping] class not found.')
      }
    }
    //
    init()
  }(window))
})