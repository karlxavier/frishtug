<template>
  <div class="row justify-content-center align-items-center review_order__container" id="review_order">
    <div class="col-md-4">
      <div class="col-12">
        <h3 class="text-uppercase text-center font-family-montserrat-medium font-size-24 mb-30px">
          Review Order
        </h3>
        <span class="font-family-montserrat font-size-18">Order Summary</span>
        <div class="row review-step__margin-b25 review-step__margin-t30">
          <div class="col-5 font-family-lato-bold font-size-14">Chosen Plan</div>
          <div class="col-7">{{ plan_name }}</div>
        </div>
        <div class="row review-step__margin-b25">
          <div class="col-5 font-family-lato-bold font-size-14" v-if="plan.interval === 'month'">5 meals per week</div>
          <div class="col-5 font-family-lato-bold font-size-14" v-else>Total meals price</div>
          <div class="col-7">{{ total_price | to_currency }}</div>
        </div>
        <div class="row review-step__margin-b25">
          <div class="col-5 font-family-lato-bold font-size-14">
            Additional Charges
          </div>
          <div class="col-7">
            {{ additional_charges() | to_currency }}
          </div>
        </div>
        <div class="row review-step__margin-b25">
          <div class="col-5 font-family-lato-bold font-size-14">
            Tax
          </div>
          <div class="col-7">
            {{ totalTax() | to_currency }}
          </div>
        </div>
        <div class="row review-step__margin-b25">
          <div class="col-5 font-family-lato-bold font-size-14">Shipping</div>
          <div class="col-7">{{ shipping_fee | to_currency }}</div>
        </div>
        <hr>
        <span class="font-family-montserrat font-size-18">Delivery Summary</span>
        <div class="row review-step__margin-b25 review-step__margin-t30">
          <div class="col-5 font-family-lato-bold font-size-14" v-if="plan.interval === 'month'">First Delivery Date</div>
          <div class="col-5 font-family-lato-bold font-size-14" v-else>Delivery Date</div>
          <div class="col-7">{{ first_delivery_date }}</div>
        </div>
        <hr>
        <div class="row review-step__margin-b25 clearfix">
          <div class="col-5">
            <strong class="font-family-montserrat font-size-18">TOTAL</strong>
          </div>
          <div class="col-7">
            <strong class="font-size-18 font-family-lato-bold" style="color: #9bc634;">
              {{ total_price + shipping_fee + additional_charges() + totalTax() | to_currency }}
            </strong>
          </div>
        </div>
        <hr>
      </div>
      <div class="col-12 text-center">
        <a href="javascript:void(0)"
          class="btn btn-brown text-uppercase complete-orders-btn"
          style="width: 203px; margin-top: 1.4rem;"
          @click="generateToken">
          Complete Sign Up
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import toCurrency from "../packs/lib/to_currency";
import moment from "moment";
import Money from "../packs/lib/money";
export default {
  data: () => {
    return {
      tax: 6.3
    };
  },
  props: {
    registration_form: { type: Object, required: true },
    stripe_key: { type: String, required: true },
    plan: { type: Object, required: true },
    charges: { type: Object, required: true },
    date: { type: Object, required: true }
  },
  filters: {
    to_currency: toCurrency,
    get_shipping_fee: shippingFee => {
      if (shippingFee > 0) {
        return toCurrency(shippingFee);
      } else {
        return "Free";
      }
    }
  },
  computed: {
    plan_name: function() {
      return this.plan.name;
    },
    shipping_fee: function() {
      return this.charges.shipping_fee;
    },
    total_price: function() {
      let total = 0
      if (this.plan.interval === "month") {
        total = this.plan.price
      } else {
        total = this.charges.total_price > this.plan.minimum_charge ? this.charges.total_price : this.plan.minimum_charge
      }
      return total;
    },
    first_delivery_date: function() {
      return moment(this.date.selected).format("MMM DD YYYY");
    }
  },
  mounted: function() {
    const self = this;
    Rails.ajax({
      url: "/api/v1/taxs",
      type: "GET",
      success: function(response) {
        self.tax = parseFloat(response.data);
      }
    });
  },
  methods: {
    additional_charges: function() {
      let additional = 0
      const self = this
      const items = self.$store.state.items
      const orders = self.registration_form.orders

      const getPrice = (item) => {
        const found = items.filter(data => data.id === item.menu_id)
        if (found.length > 0) {
          const price = Money.$cents(parseFloat(found[0].attributes.price))
          return Money.$dollar(price * item.quantity);
        } else {
          return 0;
        }
      }

      orders.forEach(order => {
        const total = Money.$dollar(order.menus_orders_attributes.reduce((sum, item) => {
          return sum += Money.$cents(getPrice(item));
        }, 0))
        if (total > self.plan.limit && self.plan.interval === 'month') {
          additional += Number((total - self.plan.limit).toFixed(2))
        }
      })
      return additional
    },
    totalTax: function() {
      const self = this
      const taxable_items = self.$store.state.items.filter(item => {
        return item.attributes.tax === true;
      }).reduce( (obj, item) => {
        obj[item.id] = item.attributes.price
        return obj
      }, {})

      const calculate_tax = (price, quantity) => {
        if (price == null) { return 0 }
        const price_in_cents = Money.$cents(price)
        const taxPercent = self.tax / 100.0
        return Money.$dollar(Money.$tax(price_in_cents, taxPercent) * quantity)
      };

      const total = self.registration_form.orders.reduce((total, order) => {
        return total += order.menus_orders_attributes.reduce(
          (sum, menu_order) => {
            return sum += Money.$cents(calculate_tax(taxable_items[menu_order.menu_id], menu_order.quantity))
          },
          0
        );
      }, 0);
      return Money.$dollar(total)
    },
    generateToken: function() {
      const self = this;
      pulse_loader.init();
      const stripeResponseHandler = (status, response) => {
        if (response.error) {
          pulse_loader.stop();
          swal({
            type: "error",
            title: "Oops...",
            text: response.error.message,
            confirmButtonText: "Ok",
            confirmButtonColor: "#582D11",
            confirmButtonClass: "btn btn-brown text-uppercase",
            buttonsStyling: false
          });
        } else {
          self.registration_form.stripe_token = response.id;
          self.registration_form.card_brand = response.card.brand;
          self.$emit("on-complete");
        }
      };
      Stripe.setPublishableKey(self.stripe_key);
      if (self.registration_form.payment_method === "credit_card") {
        Stripe.card.createToken(
          {
            number: self.registration_form.card_number.replace(/\s+/g, ""),
            exp_month: self.registration_form.month,
            exp_year: self.registration_form.year,
            cvc: self.registration_form.cvc,
            address_line1: self.registration_form.billing_line1,
            address_line2: self.registration_form.billing_line2,
            address_city: self.registration_form.billing_city,
            address_state: self.registration_form.billing_state,
            address_country: "US",
            address_zip: self.registration_form.billing_zip_code
          },
          stripeResponseHandler
        );
      } else {
        Stripe.bankAccount.createToken(
          {
            country: "US",
            currency: "usd",
            routing_number: self.registration_form.routing_number,
            account_number: self.registration_form.account_number,
            account_holder_name: null,
            account_holder_type: "individual"
          },
          stripeResponseHandler
        );
      }
    }
  }
}
</script>

<style>
.review_order__container {
  min-width: 503px;
  height: 100%;
  margin: 2rem 0;
}
</style>


