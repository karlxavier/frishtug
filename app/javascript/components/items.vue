<template>
  <div>
    <vue-tabs type="pills" @tab-change="handleTabChange">
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
          <div class="col-6 mb-4">
            <ul class="list-inline list-unstyled" role="tablist">
              <li class="list-inline-item">Order by</li>
              <li class="list-inline-item">
                <a href="javascript:void(0)" class="btn btn-sm btn-matterhorn-outline-circled font-size-14" @click="invertSort('name')">Name</a>
              </li>
              <li class="list-inline-item">
                <a href="javascript:void(0)" class="btn btn-sm btn-matterhorn-outline-circled font-size-14" @click="invertSort('price')">Price</a>
              </li>
            </ul>
          </div>
          <div class="container-fluid">
            <div class="row" v-if="items[category.attributes.name]">
              <div class='card col-12 col-custom-255 px-0 border-0 mb-4 mt-1 mr-4'
                v-for="item in sortItems(category.attributes.name)" v-bind:key="`${item.id}-${prefix}`">
                <img :src="imageUrl(item)" class="card-img-top" @click="nutriFacts(item)" width="255" height="175" style="cursor: pointer;">
                <div class="card-body px-0 py-1">
                  <h5 class="card-title mb-0 font-family-montserrat">
                    {{ item.attributes.name }}
                    <template v-for="diet in item.attributes.diet_categories">
                      <span :class="dietClass(diet)" v-bind:key="diet.id"></span>
                    </template>
                  </h5>
                  <div class="row" v-show="!!item.attributes.notes">
                    <div class="col">
                      <p class="card-text font-size-14 text-info">
                        {{ item.attributes.notes }}
                      </p>
                    </div>
                  </div>
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
                        @click="removeItem(item, date, $event)">
                        -
                      </a>
                      <span class="meal-counter">
                        {{ displayQuantity(item, date) }}
                      </span>
                      <a href="javascript:void(0)"
                        class="ctrl-btns btn btn-brown meal-ctrl-btns-minus rounded-0 cart-controls__remove"
                        @click="addItem(item, date, $event)">
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
                            :checked="isAddOnChecked(add_on.id, item, date)"
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
    <nutritional-data-modal v-bind:nutri="nutri" v-bind:item="item" v-bind:id="`nutritional-modal-${prefix}`"></nutritional-data-modal>
  </div>
</template>

<script>
import toCurrency from '../packs/lib/to_currency';
import { VueTabs, VTab } from 'vue-nav-tabs';
import lodash from 'lodash';
import axios from 'axios';
import NutritionalDataModal from './nutritional_data_modal';
import NoImage from '../packs/images/no-image.svg';

export default {
  filters: {
    to_currency: toCurrency
  },
  components: {
    VueTabs,
    VTab,
    NutritionalDataModal
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
      counter: 0,
      sortAsc: true,
      sortBy: 'display_order',
      nutri: null,
      item: {
        attributes: {
          name: '',
          description: ''
        }
      }
    };
  },
  methods: {
    isAddOnChecked: function(add_on_id, item, date) {
      const self = this;
      const found_order = self.registration_form.orders.filter(
        m => m.order_date === date
      );
      if (found_order.length > 0) {
        const found_item = found_order[0].menus_orders_attributes.filter(
          m => m.menu_id === item.id
        );
        if (found_item.length > 0) {
          return found_item[0].add_ons.includes(add_on_id);
        }
      }

      return false;
    },
    displayQuantity: function(item, date) {
      const self = this;
      const found_order = self.registration_form.orders.filter(
        m => m.order_date === date
      );
      if (found_order.length > 0) {
        const found_item = found_order[0].menus_orders_attributes.filter(
          m => m.menu_id === item.id
        );
        return found_item.length > 0 ? found_item[0].quantity : '0';
      }

      return '0';
    },
    toggleAddOn: function(add_on_id, item, date, event) {
      const self = this;
      const item_id = item.id.toString();
      self.registration_form.orders.forEach(order => {
        if (order.order_date === date) {
          order.menus_orders_attributes.forEach(menus_order => {
            if (menus_order.menu_id === item_id) {
              if (
                menus_order.add_ons.includes(add_on_id) &&
                !event.target.checked
              ) {
                const index_for_removal = menus_order.add_ons.indexOf(
                  add_on_id
                );
                menus_order.add_ons.splice(index_for_removal, 1);
              } else {
                menus_order.add_ons.push(add_on_id);
              }
            }
          });
        }
      });
    },
    addItem: function(item, date, event) {
      event.target.classList.add('disabled');
      const self = this;
      const item_id = item.id;
      const order = self.registration_form.orders.find(order => {
        return order.order_date === date;
      });

      const outOfStock = response => {
        event.target.classList.remove('disabled');
        swal({
          type: response.status,
          title: 'Error',
          text: response.message,
          confirmButtonText: 'Ok',
          confirmButtonColor: '#582D11',
          confirmButtonClass: 'btn btn-brown text-uppercase',
          buttonsStyling: false
        });
      };

      const checkInventory = (id, quantity) => {
        return new Promise((resolve, reject) => {
          Rails.ajax({
            url: `/inventories?menu_id=${id}&quantity=${quantity}`,
            type: 'GET',
            success: resolve,
            error: reject
          });
        });
      };

      for (let order of self.registration_form.orders) {
        if (order.order_date === date) {
          let found = 0;
          for (let menus_order of order.menus_orders_attributes) {
            if (menus_order.menu_id === item_id) {
              found++;
              const qty = self.$store.state.item_quantities[item_id] + 1;
              checkInventory(item_id, qty).then(function(response) {
                menus_order.quantity += 1;
                self.$store.commit('increment_item_qty', item_id);
                event.target.classList.remove('disabled');
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
                self.$store.commit('increment_item_qty', item_id);
              } else {
                self.$store.commit('new_item_qty', item_id);
              }
              event.target.classList.remove('disabled');
              if (response.notes) {
                setTimeout(function() {
                  toastr.options = {
                    closeButton: true,
                    progressBar: true,
                    showMethod: 'slideDown',
                    positionClass: 'toast-bottom-left',
                    timeOut: 7000
                  };
                  toastr.warning(response.notes, 'Notes');
                }, 100);
              }
            }, outOfStock);
          }
        }
      }
    },
    removeItem: function(item, date, event) {
      event.target.classList.add('disabled');
      const self = this;
      const item_id = item.id;
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
              self.$store.commit('decrement_item_qty', item_id);
              event.target.classList.remove('disabled');
              return;
            }
          }
          event.target.classList.remove('disabled');
        }
      }
    },
    dietClass: function(diet) {
      const diet_name = diet.name;
      const formatted = diet_name.replace(/\s+/g, '-').toLowerCase();
      return `fa fa-star diet-icons ${formatted}`;
    },
    imageUrl: function(item) {
      const asset = item.attributes.asset;
      if (asset === null) {
        return NoImage;
      }
      if (asset.hasOwnProperty('image')) {
        return asset.image.card.url;
      }
    },
    sortItems: function(cat_name) {
      const items = Array.from(this.items[cat_name]);
      let ascDesc = this.sortAsc ? 1 : -1;
      if (this.sortBy === 'display_order') {
        return items.sort((a, b) => {
          if (!a.attributes.display_order) {
            return 1;
          }

          if (!b.attributes.display_order) {
            return -1;
          }

          if (a.attributes.display_order === b.attributes.display_order) {
            return 0;
          }

          if (this.sortAsc) {
            return a.attributes.display_order < b.attributes.display_order
              ? -1
              : 1;
          }
        });
      } else {
        return items.sort(
          (a, b) =>
            ascDesc *
            a.attributes[this.sortBy].localeCompare(b.attributes[this.sortBy])
        );
      }
    },
    handleTabChange(tabIndex, newTab, oldTab) {
      this.searchText = '';
    },
    invertSort(sortBy) {
      this.sortBy = sortBy;
      this.sortAsc = !this.sortAsc;
    },
    nutriFacts: function(item) {
      const self = this;
      const item_id = item.id;
      self.item = item;
      axios.interceptors.response.use(
        response => {
          return response;
        },
        error => {
          if (error.response.status === 404) {
            console.log('Err-404 menu dont have nutritional data');
          }
          return Promise.reject(error.response);
        }
      );

      axios({
        method: 'GET',
        url: `/api/v1/nutritional_data/${item_id}`,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name=csrf-token]')
            .content
        }
      })
        .then(response => {
          self.nutri = response.data;
          $(`#nutritional-modal-${self.prefix}`).modal('show');
        })
        .catch(error => {
          console.log(error.response);
          if (
            item.attributes.description != null &&
            item.attributes.description.trim() !== ''
          ) {
            $(`#nutritional-modal-${self.prefix}`).modal('show');
          }
        });
    }
  }
};
</script>
