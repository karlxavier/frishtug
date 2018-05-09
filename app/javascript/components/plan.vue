<template>
  <div class="container">
    <h3 class="text-uppercase text-center font-family-montserrat-medium font-size-24"
      style="margin-top: 2.3rem; margin-bottom: 2.2rem;">
      Choose A Plan
    </h3>
    <div class="card-deck" style="margin-bottom: 1.7rem;">
      <template v-for="plan in plans">
        <div class="card rounded0 text-center" v-bind:key="plan.id">
          <img class="card-img-top card__plan_image" :src="images[plan.attributes.name]" alt="Card image cap">
          <div class="card-body card__plan_body">
            <h4 class="card-title">
              {{ plan.attributes.name }}
            </h4>
            <p class="card-text plan--description">
              <span v-html="plan.attributes.short_description"></span>
            </p>
            <p class="card-text" v-show="plan.attributes.shipping === 'free'">
              FREE DELIVERY!
            </p>
            <p class="card-text" v-show="plan.attributes.shipping === 'paid'">
              <span v-html="plan.attributes.shipping_note"></span>
            </p>
            <p class="card-text text-upcase">Note:</p>
            <small class="card-text text-left card__plan_note_text">
              <span v-html="plan.attributes.description"></span>
            </small>
          </div>
          <div class="card-footer card__plan_footer">
            <a href="javascript:void(0)"
              class="btn btn-block btn-brown plan--btns"
              @click="choosePlan(plan)">
              Choose {{ plan.attributes.name }}
            </a>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
import Option1 from '../packs/images/option1.png'
import Option2 from '../packs/images/option2.png'
import Option3 from '../packs/images/option3.png'
import Option4 from '../packs/images/option4.png'
export default {
  name: 'plan',
  props: {
    registration_form: { type: Object, required: true },
    plan: { type: Object, required: true },
    charges: { type: Object, required: true },
  },
  data: () => {
    return {
      plans: null,
      images: {
        "Option 1": Option1,
        "Option 2": Option2,
        "Option 3": Option3,
        "Option 4": Option4
      }
    }
  },
  mounted: function() {
    const self = this
    Rails.ajax({
      url: '/api/v1/plans',
      type: 'GET',
      success: function(response) {
        self.plans = response.data
      }
    })
  },
  methods: {
    parseFloatingNumber: function(num) {
      const val = parseFloat(num);
      return isNaN(val) ? 0 : val;
    },
    choosePlan: function(plan) {
      this.registration_form.plan_id = plan.id
      this.plan.name = plan.attributes.name
      this.plan.for_type = plan.attributes.for_type
      this.plan.interval = plan.attributes.interval
      this.plan.limit = this.parseFloatingNumber(plan.attributes.limit)
      this.plan.minimum = this.parseFloatingNumber(plan.attributes.minimum_credit_allowed)
      this.charges.shipping_fee = this.parseFloatingNumber(plan.attributes.shipping_fee)

      if (plan.attributes.interval === 'month') {
        this.plan.price = this.parseFloatingNumber(plan.attributes.price)
      }
      this.$emit('next-tab')
    }
  }
}
</script>

