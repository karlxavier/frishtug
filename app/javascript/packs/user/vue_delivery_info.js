import Vue from 'vue/dist/vue.esm'
import swal from 'sweetalert2'
import ajax from '../lib/ajax_lib'
import VueMask from "v-mask"
import LabelEdit from '../../components/label_edit'
Vue.use(VueMask)

const el = document.querySelector('#user_delivery_info')
const el2 = document.querySelector('#user_address_list')

if (el) {
  const addresses = JSON.parse(el.dataset.addresses)
  addresses.forEach(address => {
    address._delete = null
  })

  const addresses_list = JSON.parse(el2.dataset.addresses)

  const userAddressList = new Vue({
    el: el2,
    data: {
      addresses: addresses
    },
    methods: {
      fullAddress: function (address) {
        const add = [address.line1, address.line2, address.city, address.state, 'US']
        return add.filter(n => n != null && n.length > 0).join(', ')
      },
      setActiveAddress: function (address) {
        const self = this
        Rails.ajax({
          url: `/user/set_active_addresses?address_id=${address.id}`,
          type: 'GET',
          success: function (response) {
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
    components: {
      LabelEdit
    },
    data: {
      addresses: addresses,
      show: false,
      zipcodes: []
    },
    mounted: function() {
      const self = this
      const fetchAllowedZip = () => {
        return new Promise(resolve => {
          Rails.ajax({
            url: "/api/v1/allowed_zip_codes",
            type: "GET",
            success: resolve
          });
        });
      };

      fetchAllowedZip().then(function(response) {
        self.zipcodes = Array.from(response.data).map(
          data => data.attributes.zip
        );
      });
    },
    methods: {
      verifyAddress: function() {
        const self = this
        const invalids = []
        let processedAddress = 0

        const validate_address = address => {
          return new Promise((resolve, reject) => {
            Rails.ajax({
              url: `/api/v1/address?${address}`,
              type: "GET",
              success: function (response) {
                resolve(response.valid);
              }
            });
          });
        };

        const done = () => {
          if (invalids.length > 0) {
            swal({
              type: "error",
              title: "Address Not Valid!",
              text: invalids.join("|"),
              confirmButtonText: "Ok",
              confirmButtonColor: "#582D11",
              confirmButtonClass: "btn btn-brown text-uppercase",
              buttonsStyling: false
            });
          } else {
            self.saveChanges();
          }
        }

        self.addresses.forEach((address, index, array) => {
          processedAddress++
          const full_address = `line1=${address.line1}&line2=${address.line2}&city=${address.city}&state=${address.state}&zip_code=${address.zip_code}`

          validate_address(full_address).then(response => {
            if (!response) {
              invalids.push(full_address);
            }

            if (processedAddress === array.length) {
              done()
            }
          });
        });
      },
      saveChanges: () => {
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
      validateZip: function(event) {
        const zip = event.target.value
        if (!this.zipcodes.includes(zip)) {
          swal({
            type: "error",
            title: "Oppss..",
            text: "We don't deliver to your zip code",
            confirmButtonText: "Continue",
            confirmButtonColor: "#582D11",
            confirmButtonClass: "btn btn-brown text-uppercase",
            buttonsStyling: false
          })
        }
      }
    }
  })
}