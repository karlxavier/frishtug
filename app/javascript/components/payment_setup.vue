<template>
  <div class="row justify-content-center payment-step__container">
    <div class="col-md-6 col-md-offset-4 text-center payment-step__body">
          <h4 class="text-uppercase">Payment</h4>
          <span class="font-family-lato font-size-16 text-center payment-step__gateway_text">
            We use <a href="https://stripe.com">Stripe</a> for payment.
          </span>
          <br>
          <div class="form-check form-check-inline payment_methods text-left mt-1 mb-1"
            v-for="(payment_method, index) in payment_methods" v-bind:key="payment_method">
            <label :for="payment_method" class="form-check-label payment-step__control_label">
              <input type="radio" class="form-check-input" :value="payment_method" :id="payment_method" v-model="registration_form.payment_method">
              Pay by {{ payment_method | format }}
            </label>
          </div>
          <br>
          <div class="col px-0 payment-method-container" v-if="registration_form.payment_method === 'credit_card'">
            <credit-card v-bind:registration_form="registration_form" @on-next-tab="$emit('next-tab')"></credit-card>
          </div>
          <div class="col px-0 payment-method-container" v-else>
            <checking v-bind:registration_form="registration_form" @on-next-tab="$emit('next-tab')"></checking>
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
