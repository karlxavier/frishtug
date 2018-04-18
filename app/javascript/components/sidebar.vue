<template>
  <div class="meal-sidebar">
    <div class="meal-sidebar__header">
      <div class="col-8">
        <h5 class="text-uppercase font-size-18">Your Meals</h5>
      </div>
      <div class="col-4">
        <a href="javascript:void(0)" class="btn btn-outline-dark btn-sm font-size-12" @click="$emit('on-sidebar-hide')">Hide Meals</a>
      </div>
    </div>
    <div class="order-field meal-sidebar__body">
      <div class="col">
        <div class="order-list">
          <div v-for="(order, index) in orders" v-bind:key="order.order_date">
            <div class="mt-3" v-if="order.menus_orders_attributes">
              <h6 class="text-upperclass order-title mb-0"
                :id="order.order_date | to_dddd">
                {{ order.order_date | to_dddd }}
              </h6>
              <div v-for="item in order.menus_orders_attributes" v-bind:key="item.id">
                <div class="row order-list-items px-3">
                  <div class="col-7 px-0 text-left text-truncate">
                    <strong>{{ itemName(item) }}</strong>
                  </div>
                  <div class="col-3 px-0 text-center">
                    <a href="javascript:void(0)"
                      class="remove-meal mx-1 chocolate-font-color"
                      @click="removeItem(item, order.order_date, $event)">
                      <i class="fa fa-minus-square-o"></i>
                    </a>
                    <span class="quantity">
                      {{ item.quantity }}
                    </span>
                    <a href="javascript:void(0)"
                      class="add-meal mx-1 chocolate-font-color"
                      @click="addItem(item, order.order_date, $event)">
                      <i class="fa fa-plus-square-o"></i>
                    </a>
                  </div>
                  <div class="col-2 px-0 text-right" v-if="taxableItem(item)">
                    {{ removeTax(totalPrice(item)) | to_currency }}
                  </div>
                  <div class="col-2 px-0 text-right" v-else>
                    {{ totalPrice(item) | to_currency }}
                  </div>
                </div>
                <div class="row order-list-items px-3" v-for="add_on in item.add_ons" v-bind:key="`item_add_ons_${add_on}_${item.id}`">
                  <div class="col-7 px-0 text-left text-truncate">
                    <strong>{{ addOnName(item, add_on) }}</strong>
                  </div>
                  <div class="col-3 px-0 text-center">
                    <span class="meal-count">{{ item.quantity }}</span>
                  </div>
                  <div class="col-2 px-0 text-right">
                    {{ addOnPrice(item, add_on) | to_currency }}
                  </div>
                </div>
              </div>
              <div class="row order-list-items px-3" v-if="hasTaxableItems(order.menus_orders_attributes)">
                <div class="col-10 px-0 text-left text-truncate">
                  <strong>Tax</strong>
                </div>
                <div class="col-2 px-0 text-right">
                  {{ taxPrice(order.menus_orders_attributes) | to_currency }}
                </div>
              </div>
              <hr>
              <div>
                <h6 class="font-weight-bold">
                  Total
                  <span class="meal-total float-right mb-4">
                    {{ totalPlusAddOn(order.menus_orders_attributes) | to_currency }}
                  </span>
                </h6>
              </div>
              <div v-if="totalPlusAddOn(order.menus_orders_attributes) > plan.limit">
                <small class="alert alert-warning d-flex" style="font-size: 9px; width: 100%;">
                  <i class="fa fa-exclamation-circle font-size-24 pr-1" aria-hidden="true"></i>
                  You have exceeded your plan limit of $ {{ plan.limit }} for {{ order.order_date | to_dddd }}.
                  Any excess will be charge directly to your account.
                </small>
              </div>
              <div v-if="hasAvailableCredit(order, index)">
                <small class="alert alert-info d-flex" style="font-size: 10px; width: 100%;">
                  <i class="fa fa-info-circle font-size-24 pr-1" aria-hidden="true"></i>
                  Order not finished, because you still have $ {{ remainingCredits(order, index) }} credits available
                  for {{ order.order_date | to_dddd }}.
                </small>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="meal-sidebar__bottom_addon">
      <p class="font-size-12 font-family-lato">
        <strong>NOTE:</strong> Group Discount will be applied upon <br>
        acceptance by other group members. Your card will <br>
        not be charged until the others complete their orders.
      </p>
    </div>
    <div class="meal-sidebar__footer">
      <div class="col">
        <a href="javascript:void(0)" class="btn btn-brown btn--save-meal-plan btn-block" @click="verifyOrders">
          Save Meal Plan
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import swal from "sweetalert2";
import moment from "moment";
import toCurrency from "../packs/lib/to_currency";
export default {
  props: {
    registration_form: { type: Object, required: true },
    unreduce_items: { type: Array, required: true },
    plan: { type: Object, required: true },
    charges: { type: Object, required: true }
  },
  data: function() {
    return {
      orders: this.registration_form.orders,
      tax: null,
      total_without_tax: {
        day_1: 0,
        day_2: 0,
        day_3: 0,
        day_4: 0,
        day_5: 0
      },
      counter: 0
    };
  },
  filters: {
    to_currency: toCurrency,
    to_dddd: date => moment(date).format("dddd")
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

    const scroller = function() {
      let cartSidebar = document.querySelector(".meal-sidebar");
      var y = window.pageYOffset;

      const positionElelement = el => {
        if (el) {
          el.classList.add("position-fixed");
          el.style.marginTop = "7rem";
        }
      };

      const removePositioning = el => {
        if (el) {
          el.classList.remove("position-fixed");
          el.style.marginTop = "0";
        }
      };

      if (y >= 90) {
        positionElelement(cartSidebar);
      } else {
        removePositioning(cartSidebar);
      }
    };

    window.addEventListener("scroll", scroller);
  },
  methods: {
    remainingCredits: function(order, index) {
      const self = this;
      const total = self.totalWithoutTax(order.menus_orders_attributes, index);
      return (self.plan.limit - total).toFixed(2);
    },
    verifyOrders: function() {
      const self = this;
      let complete = false;
      const total = self.registration_form.orders.reduce((sum, order) => {
        const total = order.menus_orders_attributes.reduce(
          (sum, menus_order) => {
            return (sum += self.totalPrice(menus_order));
          },
          0
        );
        if (total > self.plan.limit && self.plan.limit !== 0) {
          self.charges.additional_charges += total - self.plan.limit;
        } else {
          self.charges.additional_charges = 0;
        }
        return (sum += total);
      }, 0);

      const checkLimit = value => {
        return self.parseFloatingNumber(value) >= self.plan.minimum;
      };

      if (self.plan.interval === "month") {
        complete = Object.values(self.total_without_tax).every(checkLimit);
      } else {
        complete = total > 0;
      }

      if (complete) {
        self.charges.total_price = total;

        swal({
          title: "Congratulations!",
          text: "You have made your first meal plan.",
          type: "success",
          confirmButtonText: "REVIEW ORDER",
          confirmButtonColor: "#582D11",
          confirmButtonClass: "btn btn-brown text-uppercase",
          buttonsStyling: false
        }).then(function() {
          self.$emit("on-next-tab");
        });
      } else {
        swal({
          type: "error",
          title: "Error",
          text: "Please complete your meals for each day.",
          confirmButtonText: "Ok",
          confirmButtonColor: "#582D11",
          confirmButtonClass: "btn btn-brown text-uppercase",
          buttonsStyling: false
        });
      }
    },
    addItem: function(item, date, event) {
      event.target.classList.add('disabled')
      const self = this;
      const item_id = item.menu_id;

      const outOfStock = response => {
        event.target.classList.remove('disabled')
        swal({
          type: response.status,
          title: "Error",
          text: response.message,
          confirmButtonText: "Ok",
          confirmButtonColor: "#582D11",
          confirmButtonClass: "btn btn-brown text-uppercase",
          buttonsStyling: false
        });
      };

      const checkInventory = (id, quantity) => {
        return new Promise((resolve, reject) => {
          Rails.ajax({
            url: `/inventories?menu_id=${id}&quantity=${quantity}`,
            type: "GET",
            success: resolve,
            error: reject
          });
        });
      };

      for (let order of self.registration_form.orders) {
        if (order.order_date === date) {
          let found = 0
          for (let menus_order of order.menus_orders_attributes) {
            if (menus_order.menu_id === item_id) {
              found++
              const qty = self.$store.state.item_quantities[item_id] + 1;
              checkInventory(item_id, qty).then(function(response) {
                menus_order.quantity += 1;
                self.$store.commit("increment_item_qty", item_id);
                event.target.classList.remove('disabled')
              }, outOfStock);
              return;
            }
          }

          if (found === 0) {
            const qty =
              self.$store.state.item_quantities[item_id] > 0
                ? self.$store.state.item_quantities[item_id] + 1
                : 1;
            checkInventory(item_id, qty).then(function(response) {
              order.menus_orders_attributes.push({
                menu_id: item_id,
                quantity: 1,
                add_ons: []
              });
              if (self.$store.state.item_quantities[item_id]) {
                self.$store.commit("increment_item_qty", item_id);
              } else {
                self.$store.commit("new_item_qty", item_id);
              }
              event.target.classList.remove('disabled')
            }, outOfStock);
          }
        }
      }
    },
    removeItem: function(item, date, event) {
      event.target.classList.add('disabled')
      const self = this;
      const item_id = item.menu_id;

      for (let order of self.registration_form.orders) {
        if (order.order_date === date) {
          for (let [
            index,
            menus_order
          ] of order.menus_orders_attributes.entries()) {
            if (menus_order.menu_id === item_id) {
              menus_order.quantity -= 1;
              if (menus_order.quantity <= 0) {
                order.menus_orders_attributes.splice(index, 1);
              }
              self.$store.commit("decrement_item_qty", item_id);
              event.target.classList.remove('disabled')
              return;
            }
          }
          event.target.classList.remove('disabled')
        }
      }
    },
    removeTax: function(price) {
      const self = this;
      const tax = self.tax / 100;
      const totalTaxRemove = price * tax;
      return (price - totalTaxRemove).toFixed(2);
    },
    taxableItem: function(item) {
      const self = this;
      const found = self.unreduce_items.filter(i => i.id === item.menu_id);
      if (found.length > 0) {
        return found[0].attributes.tax;
      }
    },
    itemName: function(item) {
      const self = this;
      const found = self.unreduce_items.filter(i => i.id === item.menu_id);
      if (found.length > 0) {
        return found[0].attributes.name;
      } else {
        return "Not Found Item";
      }
    },
    parseFloatingNumber: function(num) {
      const val = parseFloat(num);
      return isNaN(val) ? 0 : val;
    },
    hasAvailableCredit: function(order, index) {
      const self = this;
      const price = self.totalWithoutTax(order.menus_orders_attributes, index);
      if (self.plan.interval !== "month") {
        return false;
      }
      const minimum = self.plan.minimum;
      const limit = self.plan.limit;
      const parsedPrice = self.parseFloatingNumber(price);
      const remainingCredit = limit - parsedPrice;

      if (remainingCredit <= 0) {
        return false;
      } else if (parsedPrice >= minimum) {
        return true;
      }
    },
    totalPrice: function(item) {
      const self = this;
      const found = self.unreduce_items.filter(i => i.id === item.menu_id);
      if (found.length > 0) {
        const total = parseFloat(found[0].attributes.price) * item.quantity;
        return total;
      } else {
        return 0;
      }
    },
    addOnName: function(item, add_on_id) {
      const self = this;
      const found = self.unreduce_items.filter(i => i.id === item.menu_id);
      if (found.length > 0) {
        const add_on = found[0].meta.add_ons.filter(
          add_on => add_on.id === add_on_id
        );
        return add_on[0].name;
      }
    },
    addOnPrice: function(item, add_on_id) {
      const self = this;
      const found = self.unreduce_items.filter(i => i.id === item.menu_id);
      if (found.length > 0) {
        const add_on = found[0].meta.add_ons.filter(a => {
          return a.id === add_on_id;
        });
        return add_on[0].price;
      }
    },
    hasTaxableItems: function(menus_orders) {
      const self = this;
      const item_ids = menus_orders.map(mo => mo.menu_id);
      const taxed = item => {
        if (item_ids.includes(item.id)) {
          return item.attributes.tax === true;
        }
      };
      return self.unreduce_items.some(taxed);
    },
    taxPrice: function(menus_orders) {
      const self = this;
      const item_ids = menus_orders.map(mo => mo.menu_id);
      const quantity = menus_orders.reduce((obj, i) => {
        obj[i.menu_id] = i.quantity;
        return obj;
      }, {});
      const taxed = item => {
        return item.attributes.tax === true;
      };
      return self.unreduce_items
        .filter(i => item_ids.includes(i.id))
        .filter(taxed)
        .reduce((sum, item) => {
          const tax = self.tax / 100;
          const totalTaxRemove = parseFloat(item.attributes.price) * tax;
          return (sum += totalTaxRemove.toFixed(2) * quantity[item.id]);
        }, 0);
    },
    totalPlusAddOn: function(menus_orders) {
      const self = this;
      const item_ids = menus_orders.map(i => i.menu_id);
      const quantity = menus_orders.reduce((obj, i) => {
        obj[i.menu_id] = i.quantity;
        return obj;
      }, {});
      return self.unreduce_items
        .filter(i => item_ids.includes(i.id))
        .reduce((sum, item) => {
          const add_on_price = menus_orders.reduce(
            (add_on_sum, menus_order) => {
              return (add_on_sum += menus_order.add_ons.reduce(
                (sum, add_on) => {
                  return (sum += self.addOnPrice(menus_order, add_on));
                },
                0
              ));
            },
            0
          );
          return (sum +=
            (parseFloat(item.attributes.price) + add_on_price) *
            quantity[item.id]);
        }, 0);
    },
    totalWithoutTax: function(menus_orders, index) {
      const self = this;
      const totalWithTax = self.totalPlusAddOn(menus_orders);
      const taxPrice = self.taxPrice(menus_orders);
      const total = (totalWithTax - taxPrice).toFixed(2);

      if (self.plan.interval === "month") {
        self.total_without_tax[`day_${index + 1}`] = total;
      }

      return total;
    }
  }
};
</script>