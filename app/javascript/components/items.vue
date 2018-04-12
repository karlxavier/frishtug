<template>
  <vue-tabs type="pills">
    <v-tab v-for="category in menu_categories" v-bind:key="`${category.id}-${prefix}`" :title="category.attributes.name">
      <ul class="nav justify-content-center my-4">
        <li class="nav-item mx-2">
          <strong class="text-uppercase">Legend</strong>
        </li>
        <li class="nav-item mx-2">
          <span class="fa fa-star diet-icons sugar-free mr-1"></span>
          Sugar Free
        </li>
        <li class="nav-item mx-2">
          <span class="fa fa-star diet-icons gluten-free mr-1"></span>
          Gluten Free
        </li>
        <li class="nav-item mx-2">
          <span class="fa fa-star diet-icons carb-free mr-1"></span>
          Carb Free
        </li>
        <li class="nav-item mx-2">
          <span class="fa fa-star diet-icons may-contain-allergens mr-1"></span>
          May Contain Allergens
        </li>
      </ul>
      <div class="row" :id="`${category.id}`">
        <div class="container-fluid">
          <div class="row" v-if="items[category.attributes.name]">
            <div class='card col-12 col-custom-255 px-0 border-0 mb-4 mt-1 mr-4'
              v-for="item in items[category.attributes.name]" v-bind:key="`${item.id}-${prefix}`">
              <img :src="imageUrl(item)" class="card-img-top" width="255" height="175">
              <div class="card-body px-0 py-1">
                <h5 class="card-title mb-0 font-family-montserrat">
                  {{ item.attributes.name }}
                  <template v-for="diet in item.attributes.diet_categories">
                    <span :class="dietClass(diet)" v-bind:key="diet.id"></span>
                  </template>
                </h5>
                <div class="row">
                  <div class="col-5">
                    <p class="card-text">
                      <small class="text-muted">
                        {{ item.attributes.price | to_currency }} / {{ item.attributes.unit.name }}
                      </small>
                    </p>
                  </div>
                  <div class="col cart-controls">
                    <a href="javascript:void(0)"
                      class="ctrl-btns btn btn-brown meal-ctrl-btns-minus rounded-0 cart-controls__remove"
                      @click="removeItem(item, date)">
                      -
                    </a>
                    <span class="meal-counter">
                      {{ displayQuantity(item, date) }}
                    </span>
                    <a href="javascript:void(0)"
                      class="ctrl-btns btn btn-brown meal-ctrl-btns-minus rounded-0 cart-controls__remove"
                      @click="addItem(item, date)">
                      +
                    </a>
                  </div>
                </div>
                <div class="row">
                  <div class="col" v-show="item.meta.add_ons.length > 0">
                    <ul class="list-unstyled">
                      <li v-for="add_on in item.meta.add_ons"
                        v-bind:key="`${add_on.id}-${item.id}-${prefix}`">
                        <label :for="`add_on_${add_on.id}_${item.id}_${prefix}`">
                          <input type="checkbox"
                          :name="add_on.name"
                          :id="`add_on_${add_on.id}_${item.id}_${prefix}`"
                          @click="toggleAddOn(add_on.id, item, date, $event)"
                          >
                          {{ add_on.name }}
                        </label>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </v-tab>
  </vue-tabs>
</template>

<script>
import toCurrency from "../packs/lib/to_currency";
import { VueTabs, VTab } from "vue-nav-tabs";
export default {
  filters: {
    to_currency: toCurrency
  },
  components: {
    VueTabs,
    VTab
  },
  props: {
    registration_form: { type: Object, required: true },
    items: { type: Object },
    menu_categories: { type: Array },
    prefix: { type: String },
    date: { type: String }
  },
  data: () => {
    return {
      counter: 0
    }
  },
  methods: {
    displayQuantity: function(item, date) {
      const self = this;
      const found_order = self.registration_form.orders.filter(
        m => m.order_date === date
      );
      if (found_order.length > 0) {
        const found_item = found_order[0].menus_orders_attributes.filter(
          m => m.menu_id === item.id
        );
        return found_item.length > 0 ? found_item[0].quantity : "0";
      }

      return "0";
    },
    toggleAddOn: function(add_on_id, item, date, event) {
      const self = this;
      self.counter++
      if (self.counter > 1) {
        self.counter = 0
        return
      }

      const item_id = item.id.toString();
      self.registration_form.orders.forEach(order => {
        if (order.order_date === date) {
          const add_on_exist = order.menus_orders_attributes.filter(a => {
            return a.add_ons.includes(add_on_id);
          });

          if (add_on_exist.length > 0 && !event.target.checked) {
            order.menus_orders_attributes.forEach(a => {
              if (a.menu_id === item_id) {
                const index_for_removal = a.add_ons.indexOf(add_on_id);
                a.add_ons.splice(index_for_removal, 1);
              }
            });
          } else {
            order.menus_orders_attributes.forEach(a => {
              if (a.menu_id === item_id) {
                a.add_ons.push(add_on_id);
              }
            });
          }
        }
      });
    },
    addItem: function(item, date) {
      const self = this;
      self.counter++
      if (self.counter > 1) {
        self.counter = 0
        return
      }

      const item_id = item.id;
      const order = self.registration_form.orders.find(order => {
        return order.order_date === date;
      });

      const outOfStock = response => {
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

      if (!!order) {
        const item_exist = order.menus_orders_attributes.find(
          i => i.menu_id === item_id
        );
        if (!!item_exist) {
          const qty = self.$store.state.item_quantities[item_id] + 1;
          checkInventory(item_id, qty).then(function(response) {
            order.menus_orders_attributes.forEach(i => {
              if (i.menu_id === item_id) {
                i.quantity += 1;
                self.$store.commit("increment_item_qty", item_id);
              }
            });
          }, outOfStock);
        } else {
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
          }, outOfStock);
        }
      } else {
        console.warn(`Order not found for ${date}`);
      }
    },
    removeItem: function(item, date) {
      const self = this;
      self.counter++
      if (self.counter > 1) {
        self.counter = 0
        return
      }
      const item_id = item.id;
      const order = self.registration_form.orders.find(order => {
        return order.order_date === date;
      });

      if (!!order) {
        const item_exist = order.menus_orders_attributes.filter(
          i => i.menu_id === item_id
        );
        if (item_exist.length > 0) {
          order.menus_orders_attributes.forEach((i, index) => {
            if (i.menu_id === item_id && i.quantity !== 0) {
              i.quantity -= 1;
              if (i.quantity <= 0) {
                order.menus_orders_attributes.splice(index, 1);
              }
              self.$store.commit("decrement_item_qty", item_id);
            }
          });
        }
      } else {
        console.warn(`Order not found for ${date}`);
      }
    },
    dietClass: function(diet) {
      const diet_name = diet.name;
      const formatted = diet_name.replace(/\s+/g, "-").toLowerCase();
      return `fa fa-star diet-icons ${formatted}`;
    },
    imageUrl: function(item) {
      const asset = item.attributes.asset;
      if (asset === null) {
        return null;
      }
      if (asset.hasOwnProperty("image")) {
        return asset.image.card.url;
      }
    }
  }
};
</script>
