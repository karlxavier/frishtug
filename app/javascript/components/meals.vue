<template>
  <div style="position: relative">
    <div class="container meals_container">
      <div class="row" v-if="checkObject(items)">
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

        <div :class="show_sidebar ? 'col-md-9' : 'col'" v-else>
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

      <div class="row" v-else>
        <div class="col spinner__container">
          <div class="spinner">
            <i class="fa fa-spinner fa-spin"></i> Loading meals page...
          </div>
        </div>
      </div>
    </div>
    <sidebar v-show="show_sidebar" v-if="checkObject(items)"
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
    checkObject: function(obj) {
      return Object.keys(obj).length > 0
    },
    showShoppingCart: function() {
      console.log('test')
    }
  },
  mounted: function() {
    const self = this

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
    } else {
      self.dates.push(self.registration_form.orders[0].order_date)
    }

    const populate_items = () => {
      self.unreduce_items = self.$store.state.items
       self.menu_categories = self.$store.state.menu_categories;
      self.items = Array.from(self.$store.state.items).reduce((list, item) => {
        if (list.hasOwnProperty(item.attributes.menu_category.name)) {
          list[item.attributes.menu_category.name].push(item);
        } else {
          list[item.attributes.menu_category.name] = [];
          list[item.attributes.menu_category.name].push(item);
        }
        return list;
      }, {});
    }

    if (self.$store.state.items.length > 0) {
      populate_items()
    } else {
      Rails.ajax({
        url: "/api/v1/items",
        type: "GET",
        success: function(response) {
          self.$store.commit('populate', response.data)
          populate_items()
        }
      });

      Rails.ajax({
        url: "/api/v1/menu_categories",
        type: "GET",
        success: function(response) {
          self.$store.commit('populate_categories', response.data)
        }
      });
    }
  }
}
</script>


<style>
  .meals_page_container {
    overflow-x: hidden;
  }
  .spinner__container {
    height: calc(100vh - 12rem);
  }
  .spinner {
    text-align: center;
    width: 100%;
    display: block;
  }
</style>
