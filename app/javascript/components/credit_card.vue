<template>
  <div>
    <div class="form-group">
      <input type="text"
        id="registration_form_card_number"
        class="form-control"
        placeholder="Credit Card Number"
        data-stripe="number"
        v-model="registration_form.card_number"
        v-mask="'#### #### #### ####'">
      <div class="invalid-feedback">
        Credit Card is required
      </div>
    </div>
    <div class="form-group row">
      <div class="col">
        <select class="form-control" v-model="registration_form.month">
          <option v-for="(month, index) in months" v-bind:key="month" :value="index + 1">
            {{ month }}
          </option>
        </select>
        <div class="invalid-feedback">
          Please select a month
        </div>
      </div>
      <div class="col">
        <select class="form-control" v-model="registration_form.year">
          <option v-for="year in years" v-bind:key="year" :value="year">
            {{ year }}
          </option>
        </select>
        <div class="invalid-feedback">
          Please select a year
        </div>
      </div>
      <div class="col">
        <input type="text"
              id="registration_form_cvc"
              class="form-control"
              placeholder="CVV"
              data-stripe="cvc"
              v-model="registration_form.cvc"
              v-mask="'####'"
        >
        <div class="invalid-feedback">
          CVV is required
        </div>
      </div>
    </div>
    <div class="form-check">
      <label for="registration_form_different_billing" class="form-check-label">
        <input type="checkbox" value="true" class="form-check-input" id="registration_form_different_billing" v-model="different_billing">
        Billing address is different to delivery address
      </label>
    </div>
    <div class="different-billing" v-show="different_billing">
      <div class="form-group">
        <input type="text" class="form-control" placeholder="Address Line 1" v-model="registration_form.billing_line1">
        <div class="invalid-feedback">
          Line1 is required
        </div>
      </div>
      <div class="form-group">
        <input type="text" class="form-control" placeholder="Address Line 2" v-model="registration_form.billing_line2">
      </div>
      <div class="form-group row">
        <div class="col">
          <input type="text" class="form-control" placeholder="City" v-model="registration_form.billing_city">
          <div class="invalid-feedback">
            City is required
          </div>
        </div>
        <div class="col">
          <input type="text" class="form-control" placeholder="State" v-model="registration_form.billing_state">
          <div class="invalid-feedback">
            State is required
          </div>
        </div>
      </div>
      <div class="form-group row">
        <div class="col">
          <input type="text" class="form-control" name="registration_form[billing_zip_code]" placeholder="Zipcode" v-model.lazy="registration_form.billing_zip">
          <div class="invalid-feedback">
            Zipcode is required
          </div>
        </div>
        <div class="col">
          <input type="text" class="form-control" placeholder="Phone Number" v-model="registration_form.billing_phone_number">
        </div>
      </div>
    </div>
    <div class="text-center">
      <a href="javascript:void(0)"
        class="btn btn-brown text-uppercase payment-step__btn"
        @click="$emit('on-next-tab')">
        Continue to meal selection
      </a>
    </div>
  </div>
</template>

<script>
import moment from "moment"
export default {
  props: {
    registration_form: { type: Object, required: true }
  },
  data: () => {
    return {
      different_billing: false,
      months: moment.months(),
      years: []
    }
  },
  mounted: function() {
    let current_year = moment().year();
    const list = []
    for (let i = 0; i <= 19; i++) {
      list.push(current_year++)
    }
    this.years = list
  }
}
</script>
