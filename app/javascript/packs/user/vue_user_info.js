import Vue from 'vue/dist/vue.esm'
import swal from 'sweetalert2'

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
    }
  })
}