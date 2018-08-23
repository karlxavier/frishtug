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
  const is_party_plan = JSON.parse(el.dataset.isPartyPlan)
  const is_group_plan = JSON.parse(el.dataset.isGroupPlan)

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
      zipcodes: [],
      is_group_plan: is_group_plan
    },
    mounted: function () {
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

      fetchAllowedZip().then(function (response) {
        self.zipcodes = Array.from(response.data).map(
          data => data.attributes.zip
        );
      });

      if (self.addresses[0].location_at === "multiple_workplaces") {
        self.show = true;
      }
    },
    methods: {
      verifyAddress: function () {
        const self = this
        let processedAddress = 0
        const address_params = []
        const valid_zips = self.addresses.map(a => self.isAllowedZip(a.zip_code))

        const validate_address = address => {
          return new Promise((resolve, reject) => {
            Rails.ajax({
              url: `/api/v1/address?${address}`,
              type: "GET",
              success: function (response) {
                resolve(response);
              }
            });
          });
        };

        if (!valid_zips.every(i => i === true)) {
          self.showWeDontDeliverMsg();
          return;
        }


        self.addresses.forEach((address, index, array) => {
          processedAddress++
          address_params.push(`address[${processedAddress}][line1]=${address.line1}&address[${processedAddress}][line2]=${address.line2}&address[${processedAddress}][city]=${address.city}&address[${processedAddress}][state]=${address.state}&address[${processedAddress}][zip_code]=${address.zip_code}`)
        });

        validate_address(address_params.join('&')).then(response => {
          done(response)
        })

        const done = (response) => {
          if (response.valid === false) {
            const error_message = response.errors.reduce((list, error) => {
              return list += `<li>${error}</li>`
            }, "")

            swal({
              type: "error",
              title: "Address Not Valid!",
              html: `<ul class="list-unstyled">${error_message}</ul>`,
              confirmButtonText: "My Address Is Correct",
              confirmButtonColor: "#582D11",
              confirmButtonClass: "btn btn-brown text-uppercase mr-2",
              showCancelButton: true,
              cancelButtonText: "Cancel",
              cancelButtonClass: "btn btn-danger text-uppercase",
              buttonsStyling: false
            }).then((result) => {
              if (result.value) {
                self.saveChanges();
              } else {
                return;
              }
            });
          } else {
            response.data.forEach((data, index) => {
              self.addresses[index].state = data.state
              self.addresses[index].city = data.city
            })
            self.saveChanges();
          }
        }
      },
      saveChanges: function () {
        const self = this;
        const form = new FormData(document.querySelector('form.user_delivery_info'))
        const data = new Object()
        data.address = self.addresses
        ajax.postJson({
          url: '/user/delivery_information',
          data: data,
          success: (payload) => {
            const response = JSON.parse(payload)
            userAddressList.addresses = response.addresses
            self.addresses = response.addresses
            self.addresses.forEach(a => a._delete = null)
            swal({
              title: response.status.toUpperCase(),
              text: response.message,
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
      deleteAddress: function (address, index) {
        if (address.id !== null) {
          address._delete = 1;
          this.saveChanges();
          return;
        }
        this.addresses.splice(index, 1);
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
      isAllowedZip: function (zip) {
        if (is_party_plan === true) {
          return true;
        }

        if (!this.zipcodes.includes(zip)) {
          return false;
        } else {
          return true;
        }
      },
      validateZip: function (event) {
        const zip = event.target.value
        if (this.isAllowedZip(zip)) {
          return true;
        } else {
          this.showWeDontDeliverMsg();
        }
      },
      showWeDontDeliverMsg: function (zip) {
        swal({
          type: "error",
          title: "Oops...",
          text: "We don't deliver to your zip code",
          confirmButtonText: "Continue",
          confirmButtonColor: "#582D11",
          confirmButtonClass: "btn btn-brown text-uppercase",
          buttonsStyling: false
        })
      }
    }
  })
}