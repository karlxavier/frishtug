<template>
  <div class="row justify-content-center align-items-center" id="review_order" style="height: 503px; margin-bottom: 0.5rem;">
    <div class="col-md-4">
      <div class="col-12">
        <h3 class="text-uppercase text-center font-family-montserrat-medium font-size-24 mb-30px">
          Review Order
        </h3>
        <span class="font-family-montserrat font-size-18">Order Summary</span>
        <div class="row review-step__margin-b25 review-step__margin-t30">
          <div class="col-5 font-family-lato-bold font-size-14">Choosen Plan</div>
          <div class="col-7">{{ plan.name }}</div>
        </div>
        <div class="row review-step__margin-b25">
          <div class="col-5 font-family-lato-bold font-size-14" v-if="interval === 'month'">5 meals per week</div>
          <div class="col-5 font-family-lato-bold font-size-14" v-else>Total meals price</div>
          <div class="col-7">{{ totalCartPrice() | to_currency }}</div>
        </div>
        <div class="row review-step__margin-b25">
          <div class="col-5 font-family-lato-bold font-size-14">
            Additional Charges
          </div>
          <div class="col-7">
            {{ additionalCharges() | to_currency }}
          </div>
        </div>
        <div class="row review-step__margin-b25">
          <div class="col-5 font-family-lato-bold font-size-14">Shipping</div>
          <div class="col-7">{{ plan.shipping_fee | get_shipping_fee }}</div>
        </div>
        <hr>
        <span class="font-family-montserrat font-size-18">Delivery Summary</span>
        <div class="row review-step__margin-b25 review-step__margin-t30">
          <div class="col-5 font-family-lato-bold font-size-14" v-if="interval === 'month'">First Delivery Date</div>
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
              {{ totalCartPricePlusShippingFee() | to_currency }}
            </strong>
          </div>
        </div>
        <hr>
      </div>
      <div class="col-12">
        <div class="errors" v-if="error_messages.length > 0">
          <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Opps!..</strong>
            {{ error_messages }}
          </div>
        </div>
      </div>
      <div class="col-12 text-center">
        <a href="javascript:void(0)"
          class="btn btn-brown text-uppercase complete-orders-btn"
          style="width: 203px; margin-top: 1.4rem;"
          @click="createToken()">
          Complete Sign Up
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import toCurrency from "../packs/lib/to_currency";
export default {
  data: () => {
    return {
      error_messages: ""
    }
  },
  props: {
    stripe_key: { type: String, required: true },
    cart: { type: Array, required: true },
    plan: { type: Object, required: true },
    interval: { type: String, required: true },
    first_delivery_date: { type: String, required: true },
    credit_card_billing_address: { type: Object, required: true },
    billing_address: { type: Array, required: true },
    credit_card: { type: Object, required: true },
    delivery_dates: { type: Array, required: true },
    delivery_date: { type: String, required: true},
    plan_limit: { type: Number, required: true },
    payment_method: { type: String, required: true }
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
  methods: {
    totalCartPricePlusShippingFee: function() {
      const self = this;
      if (self.interval === "month") {
        return (
          self.plan.price +
          parseFloat(self.plan.shipping_fee) +
          self.getExcessAmount()
        );
      } else {
        const total = self.cart.reduce((sum, item) => {
          return (sum += parseFloat(item.price));
        }, 0);
        const finalTotal =
          total > parseFloat(self.plan.price) ? total : self.plan.price;
        return finalTotal + parseFloat(self.plan.shipping_fee);
      }
    },
    parseFloatingNumber: function(num) {
      const val = parseFloat(num);
      return isNaN(val) ? 0 : val;
    },
    getExcess: function() {
      const self = this
      let price = 0;
      const limit = self.parseFloatingNumber(self.plan_limit);
      if (self.cart[0]) {
        let i;
        for (i = 0; i <= 4; i++) {
          const currentCartItems = self.cart[0][`day_${i + 1}`];
          const total_prices = currentCartItems
            .map(item => item.price)
            .reduce((sum, price) => {
              return (sum += self.parseFloatingNumber(price));
            }, 0);

          const add_ons_price = currentCartItems.map(i => {
            return i.add_ons
              .map(a => a.price)
              .reduce((sum, d) => (sum += self.parseFloatingNumber(d)), 0);
          });

          const add_ons_total_price =
            add_ons_price.length > 0 ?
            add_ons_price.reduce((sum, a) => sum + a) :
            0;

          const totalItemPrice = total_prices + add_ons_total_price;
          price += totalItemPrice - limit > 0 ? totalItemPrice - limit : 0;
        }
      }
      return price;
    },
    additionalCharges: function() {
      const self = this;
      if (self.interval === "month" && self.cart) {
        return self.getExcessAmount();
      } else {
        return 0;
      }
    },
    totalCartPrice: function() {
      const self = this;
      if (self.interval === "month") {
        return self.plan.price;
      } else {
        const total = self.cart.reduce((sum, item) => {
          return (sum += parseFloat(item.price));
        }, 0);
        return total > parseFloat(self.plan.price) ? total : self.plan.price;
      }
    },
    createToken: function() {
      pulse_loader.init("Processing data...");
      const _this = this;
      const form = document.querySelector("form#sign_up_form");
      let address;

      Stripe.setPublishableKey(_this.stripe_key);
      if (_this.payment_method === "credit_card") {
        if (_this.hasAddress(_this.credit_card_billing_address)) {
          address = _this.credit_card_billing_address;
        } else {
          address = _this.billing_address[0];
        }

        Stripe.card.createToken(
          {
            number: _this.credit_card.number.replace(/\s+/g, ""),
            exp_month: _this.credit_card.exp_month,
            exp_year: _this.credit_card.exp_year,
            cvc: _this.credit_card.cvc,
            address_line1: address.address_line1,
            address_line2: address.address_line2,
            address_city: address.address_city,
            address_state: address.address_state,
            address_country: address.address_country,
            address_zip: address.address_zip
          },
          _this.stripeResponseHandler
        );
      } else {
        Stripe.bankAccount.createToken(
          _this.bank_account,
          _this.stripeResponseHandler
        );
      }
    },
    stripeResponseHandler: function(status, response) {
      const self = this
      const form = document.querySelector("form#sign_up_form");

      if (response.error) {
        self.error_messages = response.error.message;
        pulse_loader.stop()
      } else {
        const token = response.id;
        const brand = response.card.brand;
        self.completeAction(token, brand);
      }
    },
    completeAction: function(token, brand) {
      const self = this;
      const cart = self.cart;
      const form = document.querySelector("form#sign_up_form");
      const formData = new FormData(form);

      if (self.interval === "month") {
        let i;
        for (i = 0; i <= 4; i++) {
          let form_name = `registration_form[orders][${i}]`;
          let current_cart = cart[0][`day_${i + 1}`];
          formData.append(`${form_name}[order_date]`, self.delivery_dates[i]);
          formData.append(
            `${form_name}[menu_ids][]`,
            self.extractValue(current_cart, "id")
          );
          formData.append(
            `${form_name}[quantities][]`,
            self.extractValue(current_cart, "quantity")
          );
          self.addAddOnsToForm(formData, form_name, current_cart);
        }
      } else {
        let form_name = "registration_form[orders][0]";
        formData.append(`${form_name}[order_date]`, self.delivery_date);
        formData.append(`${form_name}[menu_ids][]`, self.extractValue(cart, "id"));
        formData.append(
          `${form_name}[quantities][]`,
          self.extractValue(cart, "quantity")
        );
        self.addAddOnsToForm(formData, form_name, cart);
      }

      formData.append("registration_form[stripe_token]", token);
      formData.append("registration_form[card_brand]", brand);
      Rails.ajax({
        url: form.action,
        type: "POST",
        data: formData,
        success: data => {
          eval(data);
        }
      });
    },
    extractAddOns: function(item) {
      return item.add_ons.map(add_on => add_on.id);
    },
    addAddOnsToForm: function(form, form_name, items) {
      const self = this
      items.forEach((item, index) => {
        form.append(`${form_name}[add_ons][${index}][ids]`, self.extractAddOns(item));
      });
    },
    extractValue: function(obj, valueToExtract) {
      return obj.map(item => item[valueToExtract]);
    },
    hasAddress: function(address) {
      const to_validate = [
        "address_line1",
        "address_city",
        "address_state",
        "address_zip"
      ];
      let is_valid = true;
      to_validate.forEach(key => {
        is_valid = address[key] !== "";
        if (!is_valid) {
          return;
        }
      });
      return is_valid;
    }
  }
}
</script>

