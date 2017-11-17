import Vue from 'vue/dist/vue.esm'
import swal from 'sweetalert2'
import { $US_phone_only } from '../lib/input_helpers'

const el = document.querySelector('#user_info')
if (el) {
  const user = JSON.parse(el.dataset.user)
  const phone = el.dataset.phoneNumber
  const userInfo = new Vue({
    el: el,
    data: {
      user: user,
      phone: phone,
      url: '/user/user_information'
    },
    methods: {
      onlyUsPhones: (event) => {
        if($US_phone_only(event.target)) {
          event.target.classList.remove('is-invalid')
        } else {
          event.target.classList.add('is-invalid')
        }
      }
    }
  })
}