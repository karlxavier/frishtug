/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import swal from 'sweetalert2'

document.addEventListener('DOMContentLoaded', () => {
  // expose globally so we can use it anywhere withou webpack
  window.swal

  const anchorsConfirm = () => {
    const anchors = document.querySelectorAll('a[data-confirmswt]')
    console.log(anchors)
    anchors.forEach( (anchor) => {
      anchor.addEventListener('click', (e) => {
        e.preventDefault()
        const message = e.dataset.dataConfirmswt
        if (!message) { return true }

        swal({
          title: message,
          type: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#3085d6',
          cancelButtonColor: '#d33',
          confirmButtonText: 'Yes, delete it!'
        }).then(function () {
          console.log('test')
        })

      })
    })
  }

  window.anchorsConfirm = anchorsConfirm
})