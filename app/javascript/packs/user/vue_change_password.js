import Vue from 'vue/dist/vue.esm'
import swal from 'sweetalert2'

const el = document.querySelector('#change_password')

if (el) {
  const changePass = new Vue({
    el: el,
    data: {
      user: {
        old_password: null,
        new_password: null,
        confirm_password: null
      }
    }
  })
}