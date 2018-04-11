<template>
  <div class="row justify-content-center payment-step__container">
    <div class="payment-step__body">
      <div class="row justify-content-center align-items-center">
        <div class="col payment-method-options">
          <h4 class="text-center text-uppercase">Payment</h4>
          <i class="font-family-lato font-size-16 text-center d-flex payment-step__gateway_text">
            We use &nbsp;<a href="https://stripe.com">Stripe</a>&nbsp; for payment lorem ipsum dolor sit amet tin consecitur lorem<br>
            uipsum dolor site sephi reyur ale dolorem.
          </i>
          <div class="form-check form-check-inline payment_methods"
            v-for="(payment_method, index) in payment_methods" v-bind:key="payment_method">
            <label :for="payment_method" class="form-check-label payment-step__control_label">

              <input type="radio" class="form-check-input" :value="payment_method" :id="payment_method" v-model="registration_form.payment_method">
              Pay by {{ payment_method | format }}
            </label>
          </div>
          <div class="col px-0 payment-method-container" v-if="registration_form.payment_method === 'credit_card'">
            <credit-card v-bind:registration_form="registration_form" @on-next-tab="$emit('next-tab')"></credit-card>
          </div>
          <div class="col px-0 payment-method-container" v-else>
            <checking v-bind:registration_form="registration_form" @on-next-tab="$emit('next-tab')"></checking>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import CreditCard from './credit_card'
import Checking from './checking'
export default {
  components: {
    CreditCard,
    Checking
  },
  props: {
    registration_form: { type: Object, required: true }
  },
  filters: {
    format: (val) => val.split('_').join(' ')
  },
  data: () => {
    return {
      payment_methods: ["credit_card", "checking"]
    }
  }
}
</script>

