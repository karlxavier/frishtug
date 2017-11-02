import VueFormWizard from 'vue-form-wizard'
import Vue from 'vue/dist/vue.esm'
import swal from 'sweetalert2'

Vue.use(VueFormWizard)
const registrationForm = new Vue({
  el: '#registration-form',
  data: {
    payment_method: 'credit_card',
    different_billing: false,
    delivery_date: document.querySelector('#start_date_0').value,
    schedule: 'monday_to_friday'
  },
  methods: {
    onComplete: function() {
      alert('Yay. Done!')
    },
    nextTab: function() {
      console.log('test: ', this.formWizard.data)
      const btn = document.querySelector('.wizard-btn')
      const click = new Event('click')
      btn.dispatchEvent(click)
    },
    changeSchedule: function() {
      const _this = this
      setTimeout(() => {
        _this.delivery_date = document.querySelector('#start_date_0').value
      }, 300)
    },
    isActiveSchedule: function(sched) {
      if (this.schedule === sched) {
        return ' btn-brown'
      } else {
        return ''
      }
    },
    formatDate: function(date) {
      const d = new Date(date)
      const days = [
        "Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"
      ];
      const monthNames = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      ];

      return `${days[d.getDay()]}, ${monthNames[d.getMonth()]} ${ d.getDate() }`
    },
    accountValidations: function() {
      const inputs = [
        "[name='registration_form[first_name]']",
        "[name='registration_form[last_name]']",
        "[name='registration_form[email]']",
        "[name='registration_form[password]']"
      ]

      return multiplePresenceValidator(inputs)
    },
    addressValidations: function() {
      const inputs = [
        "[name='registration_form[line1]']",
        "[name='registration_form[city]']",
        "[name='registration_form[state]']",
        "[name='registration_form[zip_code]']"
      ]

      return multiplePresenceValidator(inputs)
    },
    paymentValidations: function() {
      const inputs = [
        "[name='registration_form[card_number]']",
        "select[name='registration_form[month]']",
        "select[name='registration_form[year]']",
        "[name='registration_form[cvc]']",
        "[name='registration_form[billing_line_1]']",
        "[name='registration_form[billing_city]']",
        "[name='registration_form[billing_state]']",
        "[name='registration_form[billing_zip_code]']",
        "[name='registration_form[bank_name]']",
        "[name='registration_form[account_number]']",
        "[name='registration_form[routing_number]']"
      ]

      return multiplePresenceValidator(inputs)
    },
    showCongrats: function() {
      const _this = this
      swal({
        title: 'Congratulations!',
        text: "You have made your first meal plan.",
        type: 'success',
        confirmButtonColor: '#3085d6',
        confirmButtonText: 'REVIEW ORDER'
      }).then( function() {
        _this.nextTab()
        return true
      })
    }
  }
})

const multiplePresenceValidator = (inputsNameClassOrIds) => {
  let invalid = 0
  inputsNameClassOrIds.forEach( inputsNameClassOrId => {
    const input = document.querySelector(`${inputsNameClassOrId}`)
    if (!input) { return }

    if (!valueValidator(input)) {
      invalid++
    }
  })

  if (invalid > 0) {
    return false
  } else {
    return true
  }
}


const valueValidator = (input) => {
  if (input.value.trim().length === 0) {
    input.classList.add('is-invalid')
    return false
  } else {
    input.classList.remove('is-invalid')
    return true
  }
}