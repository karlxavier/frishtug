const input = document.querySelector('#copy_menu')

const successHandler = (event) => {
  const detail = event.detail
  const data = detail[0], status = detail[1], xhr = detail[2]
  swal(
    'success',
    data.message,
    'success'
  ).then((result) => {
    window.location.reload()
  })
}

const errorHandler = (event) => {
  const detail = event.detail
  const data = detail[0], status = detail[1], xhr = detail[2]
  swal(
    'error',
    status,
    'error'
  )
}

if (input) {
  input.addEventListener('ajax:success', successHandler)
  input.addEventListener('ajax:error', errorHandler)
}
