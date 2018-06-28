<template>
  <div style="position: relative">
    <div class="container meals_container">
      <div class="row" v-if="checkObject(items)">
        <div :class="show_sidebar ? 'col-md-9' : 'col'" v-if="plan.interval === 'month'">
          <go-to-top v-bind:right="show_sidebar ? 25 : 2"></go-to-top>
          <div class="menu-items__container_for_five_days">
            <scheduled-order
              v-bind:menu_categories="menu_categories"
              v-bind:items="items"
              v-bind:dates="dates"
              v-bind:registration_form="registration_form"
              @input="filterItems">
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
          <go-to-top></go-to-top>
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
                  v-bind:registration_form="registration_form"
                  @input="filterItems">
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
import GoToTop from './go_to_top'
import SingleOrder from './single_order'
import ScheduledOrder from './scheduled_order'
import Sidebar from './sidebar'
export default {
  components: {
    ScheduledOrder,
    SingleOrder,
    Sidebar,
    GoToTop
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
      show_sidebar: true,
      temp_items: {}
    }
  },
  methods: {
    checkObject: function(obj) {
      return Object.keys(obj).length > 0
    },
    showShoppingCart: function() {
      console.log('test')
    },
    invertSort(sortBy) {
      this.sortBy = sortBy
      this.sortAsc = !this.sortAsc;
    },
    filterItems: function(search_term) {
      const self = this
      const items = self.unreduce_items.filter(item => {
        return item.attributes.name.toLowerCase().includes(search_term.toLowerCase());
      });
      const filtered_categories = items.map(i => i.attributes.menu_category.name)

      if (items.length > 0) {
        self.menu_categories = self.$store.state.menu_categories.filter(cat => {
          return filtered_categories.includes(cat.attributes.name);
        })

        self.items = Array.from(items).reduce((list, item) => {
          if (list.hasOwnProperty(item.attributes.menu_category.name)) {
            list[item.attributes.menu_category.name].push(item);
          } else {
            list[item.attributes.menu_category.name] = [];
            list[item.attributes.menu_category.name].push(item);
          }
          return list;
        }, {});
      } else {
        self.menu_categories = self.$store.state.menu_categories;
        self.items = self.temp_items;
      }
    }
  },
  mounted: function() {
    const self = this
    self.dates = self.$store.state.selected_dates

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
      self.temp_items = self.items
    }

    if (self.$store.state.items.length > 0) {
      populate_items()
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
