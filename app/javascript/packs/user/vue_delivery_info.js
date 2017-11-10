import Vue from 'vue/dist/vue.esm'
import swal from 'sweetalert2'
import ajax from '../lib/ajax_lib'

window.ajax = ajax
const el = document.querySelector('#user_delivery_info')

if (el) {
  const addresses = JSON.parse(el.dataset.addresses)
  const userDelivery = new Vue({
    el: el,
    data: {
      addresses: addresses,
      show: false
    },
    methods: {
      saveChanges: () => {
        const _this = this
        const form = new FormData(document.querySelector('form.user_delivery_info'))
        const data = new Object()
        data.address = userDelivery.addresses
        ajax.postJson({
          url: '/user/delivery_information',
          data: data,
          success: (response) => {
            const data = JSON.parse(response)
            swal(
              data.status.toUpperCase(),
              data.message,
              'success'
            )
          },
          error: (response) => {
            const data = JSON.parse(response)
            swal(
              data.status.toUpperCase(),
              data.message,
              'error'
            )
          }
        })
      },
      showAddBtn: () => {
        userDelivery.show = true
      },
      hideAddBtn: () => {
        userDelivery.show = false
        userDelivery.addresses = userDelivery.addresses[0]
      },
      addAddress: () => {
        userDelivery.addresses.push({
          id: null,
          city: '',
          line1: '',
          line2: '',
          front_door: '',
          state: '',
          zip_code: '',
          location_at: 'multiple_workplaces'
        })
      }
    }
  })
}