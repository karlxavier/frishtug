<template>
  <div style="position: relative">
    <div class="container">
      <div class="row">
        <div :class="show_sidebar ? 'col-md-9' : 'col'" v-if="plan.interval === 'month'">
          <div class="menu-items__container_for_five_days">
            <scheduled-order
              v-bind:menu_categories="menu_categories"
              v-bind:items="items"
              v-bind:dates="dates"
              v-bind:registration_form="registration_form">
            </scheduled-order>
            <a href="javascript:void(0)"
              class="btn btn-outline-dark btn-sm font-size-12 shopping-cart__shown_btn"
              @click="show_sidebar = true"
              v-show="!show_sidebar">
              Show Meals
            </a>
          </div>
        </div>

        <div class="col" v-else>
          <a href="javascript:void(0)"
            class="btn btn-outline-dark btn-sm font-size-12 shopping-cart__shown_btn"
            @click="show_sidebar = true"
            v-show="!show_sidebar">
            Show Meals
          </a>
          <div id="single_order" class="mt-3 menu-item__container">
                <single-order
                  v-bind:menu_categories="menu_categories"
                  v-bind:items="items"
                  v-bind:dates="dates"
                  v-bind:registration_form="registration_form">
                </single-order>
          </div>
        </div>
      </div>
    </div>
    <sidebar v-show="show_sidebar"
      v-bind:unreduce_items="unreduce_items"
      v-bind:registration_form="registration_form"
      v-bind:plan="plan"
      v-bind:charges="charges"
      @on-sidebar-hide="show_sidebar = false"
      @on-next-tab="$emit('next-tab')"
    ></sidebar>
  </div>
</template>

<script>
import SingleOrder from './single_order'
import ScheduledOrder from './scheduled_order'
import Sidebar from './sidebar'
export default {
  components: {
    ScheduledOrder,
    SingleOrder,
    Sidebar
  },
  props: {
    plan: { type: Object, required: true },
    registration_form: { type: Object, required: true },
    date: { type: Object, required: true },
    charges: { type: Object, required: true }
  },
  data: () => {
    return {
      menu_categories: null,
      items: {},
      shopping_cart_shown: false,
      date_names: null,
      dates: [],
      unreduce_items: [],
      show_sidebar: true
    }
  },
  methods: {
    showShoppingCart: function() {
      console.log('test')
    }
  },
  mounted: function() {
    const self = this
    if (Object.keys(self.items).length > 0) { return }

    Rails.ajax({
      url: "/api/v1/items",
      type: "GET",
      success: function(response) {
        self.unreduce_items = response.data
        self.items = Array.from(response.data).reduce((list, item) => {
          if (list.hasOwnProperty(item.attributes.menu_category.name)) {
            list[item.attributes.menu_category.name].push(item);
          } else {
            list[item.attributes.menu_category.name] = [];
            list[item.attributes.menu_category.name].push(item);
          }
          return list;
        }, {});
      }
    });

    Rails.ajax({
      url: "/api/v1/menu_categories",
      type: "GET",
      success: function(response) {
        self.menu_categories = response.data;
      }
    });

    if (self.plan.interval === 'month') {
      Rails.ajax({
        url: `/api/v1/selected_dates?date=${self.date.selected}&schedule=${self.registration_form.schedule}`,
        type: 'GET',
        success: function(response) {
          const errorEl = document.querySelector(".calendar-errors");
          if (response.status === "success") {
            self.dates = response.dates
            self.date_names = response.names;
          }
        }
      })
    }
  }
}
</script>
