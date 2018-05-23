<template>
  <div>
    <div class="form-group">
      <input type="text"
        placeholder="Bank Name"
        class="form-control"
        required
        v-model="registration_form.bank_name"
        v-bind:class="{ 'is-invalid': $v.registration_form.bank_name.$error}"
        @input="$v.registration_form.bank_name.$touch">
      <div class="invalid-feedback">
        Bank name is required
      </div>
    </div>
    <div class="form-group">
      <input type="text"
      placeholder="Account Number"
      class="form-control"
      v-model="registration_form.account_number"
      v-bind:class="{ 'is-invalid': $v.registration_form.account_number.$error}"
      @input="$v.registration_form.account_number.$touch">
      <div class="invalid-feedback">
        Account number is required
      </div>
    </div>
    <div class="form-group">
      <input type="text"
      placeholder="Routing Number"
      class="form-control"
      v-model="registration_form.routing_number"
      v-bind:class="{ 'is-invalid': $v.registration_form.routing_number.$error}"
      @input="$v.registration_form.routing_number.$touch">
      <div class="invalid-feedback">
        Routing number is required
      </div>
    </div>
    <small class="text-muted">
      Account will be activated upon receiving and clearing of check
    </small>
    <div class="text-center">
      <a href="javascript:void(0)" class="btn btn-brown text-uppercase payment-step__btn" @click="validate">
        Continue to meal selection
      </a>
    </div>
  </div>
</template>

<script>
import { required } from 'vuelidate/lib/validators'
export default {
  props: {
    registration_form: { type: Object, required: true }
  },
  validations: {
    registration_form: {
      bank_name: { required },
      routing_number: { required },
      account_number: { required }
    }
  },
  methods: {
    validate: function() {
      const self = this
      self.$v.registration_form.$touch()
      const isValid = !self.$v.registration_form.$invalid
      if (isValid) {
        return self.$emit('on-next-tab')
      } else {
        swal({
          type: "error",
          title: "Oops...",
          text: "Please fill all the required fields",
          confirmButtonText: "Ok",
          confirmButtonColor: "#582D11",
          confirmButtonClass: "btn btn-brown text-uppercase",
          buttonsStyling: false
        })
        return
      }
    }
  }
}
</script>
