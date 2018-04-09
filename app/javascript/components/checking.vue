<template>
  <div>
    <div class="form-group">
      <input type="text" placeholder="Bank Name" class="form-control" required v-model="registration_form.bank_name">
      <div class="invalid-feedback">
        Bank name is required
      </div>
    </div>
    <div class="form-group">
      <input type="text" placeholder="Account Number" class="form-control" v-model="registration_form.account_number">
      <div class="invalid-feedback">
        Account number is required
      </div>
    </div>
    <div class="form-group">
      <input type="text" placeholder="Routing Number" class="form-control" v-model="registration_form.routing_number">
      <div class="invalid-feedback">
        Routing number is required
      </div>
    </div>
    <small class="text-muted">
      Account will be activated upon receiving and clearing of check
    </small>
    <div class="text-center">
      <a href="javascript:void(0)" class="btn btn-brown text-uppercase payment-step__btn" @click="$emit('on-next-tab')">
        Continue to meal selection
      </a>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    registration_form: { type: Object, required: true }
  }
}
</script>
