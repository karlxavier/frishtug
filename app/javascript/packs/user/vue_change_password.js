import Vue from 'vue/dist/vue.esm'
import swal from 'sweetalert2'
import ajax from '../lib/ajax_lib'
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
    },
    methods: {
      saveChanges: function() {
        const user = this.user
        const data = new FormData(document.querySelector('form.change_password_form'))
        if (user.new_password === user.confirm_password) {
          ajax.postForm({
            url: '/user/change_password',
            data: data,
            success: function(response) {
              const data = JSON.parse(response)
              swal(
                data.status.toUpperCase(),
                data.message,
                'success'
              )
            },
            error: function(response) {
              const data = JSON.parse(response)
              swal(
                data.status.toUpperCase(),
                data.message,
                'error'
              )
            }
          })
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