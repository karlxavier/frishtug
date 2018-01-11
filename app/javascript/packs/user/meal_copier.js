const input = document.querySelector('#copy_meals')

const copierHandler = (event) => {
  const input = event.target
  Rails.ajax({
    url: `/user/copy_meals?copy_menu=${input.checked}`,
    type: 'POST',
    success: function(response) {
      console.log(response)
      window.location.reload(true)
    },
    error: function(response) {
      console.log(response)
    }
  })
}

if (input) {
  input.addEventListener('click', copierHandler)
}
