/* eslint semi: ["error", "never"] */
import "es6-promise/auto";
import VueFormWizard from "vue-form-wizard";
import vuejsStorage from "vuejs-storage";
import VueLazyload from "vue-lazyload";
import VueMask from "v-mask";
import Vue from "vue/dist/vue.esm";
import VueRouter from "vue-router";
import Vuelidate from "vuelidate";
import Vuex from "vuex";
import VueResource from "vue-resource";
import Plan from "../components/plan";
import CreateAccount from "../components/create_account";
import DeliveryInformation from "../components/delivery_information";
import Days from "../components/days";
import PaymentSetup from "../components/payment_setup";
import Meals from "../components/meals";
import ReviewOrder from "../components/review_order";
import dotenv from 'dotenv';


if (process.env.NODE_ENV !== 'production') {
  dotenv.load();
}

// Components
Vue.use(VueFormWizard);
Vue.use(vuejsStorage);
Vue.use(VueRouter);
Vue.use(VueMask);
Vue.use(Vuelidate);
Vue.use(VueResource);
Vue.use(Vuex);
Vue.use(VueLazyload);

const store = new Vuex.Store({
  state: {
    items: [],
    menu_categories: [],
    item_quantities: {},
    selected_dates: []
  },
  mutations: {
    populate(state, data) {
      state.items.push(...data);
    },
    populate_categories(state, data) {
      state.menu_categories.push(...data);
    },
    new_selected_dates(state, dates) {
      state.selected_dates.splice(0, state.selected_dates.length);
      if (dates instanceof Array) {
        state.selected_dates.push(...dates);
      } else {
        state.selected_dates.push(dates);
      }
    },
    new_item_qty(state, id) {
      state.item_quantities[id] = 1;
    },
    increment_item_qty(state, id) {
      state.item_quantities[id] += 1;
    },
    decrement_item_qty(state, id) {
      state.item_quantities[id] -= 1;
      if (state.item_quantities[id] === 0) {
        delete state.item_quantities[id];
      }
    }
  }
});

Vue.http.headers.common["X-CSRF-Token"] = document
  .querySelector('meta[name="csrf-token"]')
  .getAttribute("content");

const router = new VueRouter({
  mode: "history",
  routes: [
    { path: "/user_registrations", component: Plan },
    { path: "/user_registrations/create_account", component: CreateAccount },
    {
      path: "/user_registrations/delivery_information",
      component: DeliveryInformation
    },
    { path: "/user_registrations/days", component: Days },
    { path: "/user_registrations/payment_setup", component: PaymentSetup },
    { path: "/user_registrations/meals", component: Meals },
    { path: "/user_registrations/review_order", component: ReviewOrder }
  ]
});

const vm = new Vue({
  router,
  el: "#registration_app",
  store: store,
  data: {
    stripe_key: process.env.STRIPE_PUBLISHABLE_KEY,
    charges: {
      total_price: null,
      additional_charges: null,
      shipping_fee: null
    },
    plan: {
      for_type: null,
      interval: null,
      limit: null,
      minimum: null,
      price: null,
      name: null,
      minimum_charge: null
    },
    date: {
      selected: null
    },
    registration_form: {
      plan_id: null,
      email: "",
      first_name: "",
      last_name: "",
      password: "",
      cvc: null,
      year: null,
      month: null,
      card_number: null,
      phone_number: null,
      group_code: null,
      routing_number: null,
      account_number: null,
      bank_name: null,
      start_date: null,
      schedule: null,
      payment_method: "credit_card",
      billing_line_1: null,
      billing_line_2: null,
      billing_city: null,
      billing_state: null,
      billing_zip_code: null,
      billing_phone_number: null,
      stripe_token: null,
      card_brand: null,
      addresses: [
        {
          line1: 'Address Line 1',
          line2: null,
          front_door: null,
          city: null,
          state: null,
          zip_code: null,
          location_at: "at_home"
        }
      ],
      orders: []
    }
  },
  storage: {
    keys: [
      "registration_form",
      "charges",
      "plan",
      "date"
    ],
    namespace: "sign_up_data",
    storage: sessionStorage
  },
  mounted: function() {
    const self = this;
    const fetchItems = () => {
      return new Promise(resolve => {
        Rails.ajax({
          url: "/api/v1/items",
          type: "GET",
          success: function(response) {
            resolve(response);
          }
        });
      });
    };

    const fetchMenuCategories = () => {
      return new Promise(resolve => {
        Rails.ajax({
          url: "/api/v1/menu_categories",
          type: "GET",
          success: function(response) {
            resolve(response);
          }
        });
      });
    };

    fetchItems().then(response => {
      self.$store.commit("populate", response.data);
    });

    fetchMenuCategories().then(response => {
      self.$store.commit("populate_categories", response.data);
    });

    const node = document.querySelector('.selected-plan');
    if (node) {
      const data = JSON.parse(node.getAttribute('data'))
      const limit = parseFloat(data.limit)
      const minimum = parseFloat(data.minimum_credit_allowed)
      const minimum_charge = parseFloat(data.minimum_charge)
      self.plan = {
        for_type: data.for_type,
        interval: data.interval,
        limit: isNaN(limit) ? 0 : limit,
        minimum: isNaN(minimum) ? 0 : minimum,
        price: parseInt(data.price),
        name: data.name,
        minimum_charge: minimum_charge
      }
      self.registration_form.plan_id = data.id
    }


    if(self.plan.name !== null) {
      self.nextTab();
    }
  },
  methods: {
    changeCompletedState: function() {
      const greenColor = "rgb(55, 196, 41)";
      const ariaLabels = [
        "CreateAccount",
        "DeliveryInformation",
        "Plan",
        "Days",
        "PaymentSetup",
        "Meals",
        "ReviewOrder"
      ];
      ariaLabels.forEach(label => {
        const el = document.querySelector(`[aria-controls^="${label}"]`);
        const isChecked = el.classList.contains("checked");
        const isActive = el.getAttribute("aria-selected");
        if (isChecked && isActive === null) {
          const icon = document.createElement("i");
          const iconContainer = document.createElement("div");
          iconContainer.className = "wizard-icon-container";
          iconContainer.style.backgroundColor = greenColor;
          icon.className = "wizard-icon fa fa-check";
          icon.style.color = "#ffffff";
          iconContainer.appendChild(icon);
          el.innerHTML = "";
          el.appendChild(iconContainer);
        } else {
          return;
        }
      });
    },
    nextTab: function() {
      const self = this;
      setTimeout(self.changeCompletedState, 300);
      self.$refs.wizard.nextTab();
    },
    complete: function() {
      const self = this;
      const successHandler = response => {
        if (self.plan.for_type === "group" && !self.registration_form.group_code) {
          pulse_loader.stop();
          swal({
            html: `
                <div class="row">
                  <div class="col text-left">
                    <h5 class="mb-3 font-family-montserrat font-size-20">Here Is Your Group Code</h5>
                    <h1 class="dashed-box text-center">
                      ${response.body.group_code}
                    </h1>
                    <i class="font-family-lato font-size-14">
                      In order to avail of the Group Plan discount, you'll need to share the Group
                      Code to at least 2 other people. Deliveries will be made to only one location.
                    </i>
                    <ul class="list-inline">
                      <li class="list-inline-item" style="margin-right: 23px;">Share:</li>
                      <li class="list-inline-item">
                        <span class="chocolate-font-color">
                        <i class="fa fa-envelope" style="margin-right: 12px; font-size: 21px;"></i>Email Code</span>
                      </li>
                      <li class="list-inline-item">
                        <span class="chocolate-font-color">
                        <i class="fa fa-mobile" style="margin-right: 12px; font-size: 30px; position: relative: bottom: -4px;"></i>Text Code</span>
                      </li>
                    </ul>
                  </div>
                </div>
              `,
            showCancelButton: false,
            confirmButtonColor: "#582D11",
            confirmButtonText: "done",
            cancelButtonText: "cancel",
            confirmButtonClass: "btn btn-brown text-uppercase",
            cancelButtonClass: "btn btn-default text-uppercase",
            buttonsStyling: false
          }).then(function(result) {
            if (result.value) {
              sessionStorage.clear();
              window.location.href = response.body.redirect_to;
            }
          });
          return
        } else {
          pulse_loader.replace_text(
            "Sign up complete!. You are being redirect to your dashboard..."
          );
        }
        sessionStorage.clear();
        window.location.href = response.body.redirect_to;
      };

      const errorHandler = response => {
        pulse_loader.stop();
        swal({
          type: "error",
          title: "Oops...",
          text: response.body.message,
          confirmButtonText: "Ok",
          confirmButtonColor: "#582D11",
          confirmButtonClass: "btn btn-brown text-uppercase",
          buttonsStyling: false
        });
      };

      this.$http
        .post("/user_registrations", {
          registration_form: this.registration_form
        })
        .then(successHandler, errorHandler);
    }
  }
});
