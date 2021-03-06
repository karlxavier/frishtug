<template>
  <div>
    <div class="row">
      <div class="col-5 mb-4">
        <input type="text" v-model="searchText" icon="search" class="form-control" placeholder="Search menu.." @input="filterItems"/>
        <p v-if="filtered_categories.length === 0">No result for {{ searchText }}</p>
      </div>
    </div>
    <vue-tabs type="pills">
      <v-tab v-for="category in filtered_categories" v-bind:key="`${category.id}`" :title="category.attributes.name">
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
            <div class="row" v-if="filtered_items_list[category.attributes.name]">
              <card
              v-for="item in sortItems(filtered_items_list[category.attributes.name])" v-bind:key="`${item.id}`"
              v-bind:item="item"
              v-bind:quantity="quantities[item.id] || 0"
              v-bind:add_on_ids="add_on_ids[item.id] || null"
              @add-item="addItem"
              @remove-item="removeItem"
              @add-add-on="addAddOn"
              @remove-add-on="removeAddOn"
              @on-image-click="nutriFacts"
              ></card>
            </div>
          </div>
        </div>
      </v-tab>
    </vue-tabs>
    <nutritional-data-modal v-bind:nutri="nutri" v-bind:item="item" v-bind:id="'menuNutriFacts'"></nutritional-data-modal>
  </div>
</template>

<script>
import { VueTabs, VTab } from 'vue-nav-tabs';
import NutritionalDataModal from '../nutritional_data_modal';
import Card from './card';
import lodash from 'lodash';
import axios from 'axios';
export default {
  components: {
    VueTabs,
    VTab,
    NutritionalDataModal,
    Card
  },
  data: () => {
    return {
      searchText: '',
      sortAsc: true,
      sortBy: 'display_order',
      menu_categories: null,
      item: {},
      filtered_items: {},
      nutri: null,
      filtered_categories: []
    };
  },
  props: ['items', 'order'],
  computed: {
    quantities: function() {
      return this.order.menus_orders_attributes.reduce((obj, item) => {
        obj[item.menu_id] = item.quantity;
        return obj;
      }, {});
    },
    add_on_ids: function() {
      return this.order.menus_orders_attributes.reduce((obj, item) => {
        obj[item.menu_id] = item.add_ons;
        return obj;
      }, {});
    },
    filtered_items_list: function() {
      const object_is_empty = Object.keys(this.filtered_items).length === 0;
      if (object_is_empty) {
        return this.items;
      } else {
        return this.filtered_items;
      }
    }
  },
  mounted() {
    const self = this;
    Rails.ajax({
      url: '/api/v1/menu_categories',
      type: 'GET',
      success: function(response) {
        self.menu_categories = response.data;
        self.filtered_categories = self.menu_categories;
      }
    });
    self.filtered_items = self.items;
  },

  methods: {
    filterItems: function() {
      const self = this;
      if (self.searchText.length <= 0) {
        self.filtered_items = {};
      }
      const list = Object.values(self.items).reduce((a, i) => {
        a.push(...i);
        return a;
      }, []);
      const items = list.filter(i =>
        i.attributes.name.toLowerCase().includes(self.searchText.toLowerCase())
      );

      const category_names = items.map(i => i.attributes.menu_category.name);

      self.filtered_categories = self.menu_categories.filter(i => {
        return category_names.includes(i.attributes.name);
      });

      self.filtered_items = items.reduce((list, item) => {
        if (list.hasOwnProperty(item.attributes.menu_category.name)) {
          list[item.attributes.menu_category.name].push(item);
        } else {
          list[item.attributes.menu_category.name] = [];
          list[item.attributes.menu_category.name].push(item);
        }
        return list;
      }, {});
    },
    sortItems: function(items) {
      const sortedItems = [...items];
      let ascDesc = this.sortAsc ? 1 : -1;
      if (sortedItems) {
        if (this.sortBy === 'display_order') {
          return sortedItems.sort((a, b) => {
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
          return sortedItems.sort(
            (a, b) =>
              ascDesc *
              a.attributes[this.sortBy].localeCompare(b.attributes[this.sortBy])
          );
        }
      } else {
        return items;
      }
    },
    invertSort(sortBy) {
      this.sortBy = sortBy;
      this.sortAsc = !this.sortAsc;
    },
    addItem: function(item, quantity) {
      this.$emit('add-item', item, quantity);
    },
    removeItem: function(item, quantity) {
      this.$emit('remove-item', item, quantity);
    },
    removeAddOn: function(add_on_id, item) {
      this.$emit('remove-add-on', add_on_id, item);
    },
    addAddOn: function(add_on_id, item) {
      this.$emit('add-add-on', add_on_id, item);
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
          $('#menuNutriFacts').modal('show');
        })
        .catch(error => {
          console.log(error.response);
          if (
            item.attributes.description != null &&
            item.attributes.description.trim() !== ''
          ) {
            $('#menuNutriFacts').modal('show');
          }
        });
    }
  }
};
</script>
