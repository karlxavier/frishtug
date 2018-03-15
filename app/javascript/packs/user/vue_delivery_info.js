import Vue from 'vue/dist/vue.esm'
import swal from 'sweetalert2'
import ajax from '../lib/ajax_lib'
import { $only_numbers, $limit } from '../lib/input_helpers'

const el = document.querySelector('#user_delivery_info')
const el2 = document.querySelector('#user_address_list')

if (el) {
  const addresses = JSON.parse(el.dataset.addresses)
  addresses.forEach( address => { address._delete = null })

  const addresses_list = JSON.parse(el2.dataset.addresses)

  const userAddressList = new Vue({
    el: el2,
    data: {
      addresses: addresses
    },
    methods: {
      fullAddress: function(address) {
        const add = [address.line1, address.line2, address.city, address.state, 'US']
        return add.filter(n => n != '').join(', ')
      },
      setActiveAddress: function(address) {
        const self = this
        Rails.ajax({
          url: `/user/set_active_addresses?address_id=${address.id}`,
          type: 'GET',
          success: function(response) {
            swal({
              title: response.status.toUpperCase(),
              text: 'Successfully change active address',
              type: "success",
              confirmButtonText: "Ok",
              confirmButtonColor: "#582D11",
              confirmButtonClass: "btn btn-brown text-uppercase",
              buttonsStyling: false
            });
            userDelivery.addresses = response.addresses
            self.addresses = response.addresses
          }
        })
      }
    }
  })

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
            userAddressList.addresses = data.addresses
            swal({
              title: data.status.toUpperCase(),
              text: data.message,
              type: "success",
              confirmButtonText: "Ok",
              confirmButtonColor: "#582D11",
              confirmButtonClass: "btn btn-brown text-uppercase",
              buttonsStyling: false
            });
          },
          error: (response) => {
            const data = JSON.parse(response)
            swal({
              title: data.status.toUpperCase(),
              text: data.message,
              type: "error",
              confirmButtonText: "Ok",
              confirmButtonColor: "#582D11",
              confirmButtonClass: "btn btn-brown text-uppercase",
              buttonsStyling: false
            });
          }
        })
      },
      showAddBtn: () => {
        userDelivery.show = true
        userDelivery.addresses.forEach((address, index) => {
          if (index !== 0) {
            address._delete = null
          }
        })
      },
      hideAddBtn: () => {
        userDelivery.show = false
        userDelivery.addresses.forEach((address, index) => {
          if (index !== 0) {
            address._delete = 1
          }
        })
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
          location_at: 'multiple_workplaces',
          _delete: null
        })
      },
      limitZipCode: (event, index) => {
        userDelivery.addresses[index].zip_code = $limit(event.target, 5)
      },
      is_numeric: (event, index) => {
        userDelivery.addresses[index].zip_code = $only_numbers(event.target)
      }
    }
  })
}