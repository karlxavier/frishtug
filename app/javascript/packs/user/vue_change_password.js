import Vue from 'vue/dist/vue.esm'
import swal from 'sweetalert2'
import ajax from '../lib/ajax_lib'
const el = document.querySelector('#change_password')

if (el) {
  const responseHandler = (data) => {
    swal(
      data.status.toUpperCase(),
      data.message,
      data.status
    );
  }

  const changePass = new Vue({
    el: el,
    data: {
      user: {
        old_password: null,
        new_password: null,
        confirm_password: null
      }
    },
    methods: {
      saveChanges: function () {
        const user = this.user
        const data = new FormData(document.querySelector('form.change_password_form'))
        if (user.new_password === user.confirm_password) {
          Rails.ajax({
            url: '/user/change_password',
            type: 'POST',
            data: data,
            success: responseHandler,
            error: responseHandler
          });
        } else {
          swal(
            'Errors',
            'New and confirm password does not match',
            'error'
          )
          return false
        }
      }
    }
  })
}