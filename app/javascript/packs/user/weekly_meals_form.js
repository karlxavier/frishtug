import Vue from "vue/dist/vue.esm";
import Items from "../../components/user_backend/items";
import Sidebar from "../../components/user_backend/sidebar";
import VueLazyload from "vue-lazyload";
import GoToTop from '../../components/go_to_top';
import toCurrency from "../lib/to_currency";

Vue.use(VueLazyload);
const node = document.querySelector("#orders-form");
const order_data = JSON.parse(node.dataset.orders)
const menus_orders = JSON.parse(node.dataset.menusOrdersAttributes)
const charges = JSON.parse(node.dataset.charges)
const pending_credits = JSON.parse(node.dataset.pendingCredits)
order_data.menus_orders_attributes = menus_orders

if (node) {
  const vm = new Vue({
    el: "#orders-form",
    data: {
      order: order_data,
      items: {},
      schedule: null,
      unreduce_items: [],
      tax: null,
      sub_total: null,
      total: null,
      shipping_fee: null,
      excess: null,
      sidebar_shown: false,
      loaded: false,
      pending_credits: pending_credits,
      selected_credit: null
    },
    filters: {
      to_currency: toCurrency
    },
    components: {
      Items,
      Sidebar,
      GoToTop
    },
    mounted() {
      const self = this
      self.schedule = JSON.parse(node.dataset.schedule)
      
      if (sessionStorage.getItem('items') === null) {
        Rails.ajax({
          url: '/api/v1/items',
          type: 'GET',
          success: function(response) {
            sessionStorage.setItem('items', JSON.stringify(response.data))
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
            self.sidebar_shown = true
            self.loaded = true
          }
        })
      } else {
        const parsedItems = JSON.parse(sessionStorage.getItem('items'))
        self.unreduce_items = parsedItems
        self.items = Array.from(parsedItems).reduce((list, item) => {
          if (list.hasOwnProperty(item.attributes.menu_category.name)) {
            list[item.attributes.menu_category.name].push(item);
          } else {
            list[item.attributes.menu_category.name] = [];
            list[item.attributes.menu_category.name].push(item);
          }
          return list;
        }, {});
        self.sidebar_shown = true
        self.loaded = true
      }

      if (self.order.menus_orders_attributes.length > 0) {
        self.order.menus_orders_attributes.forEach(item => item.menu_id = String(item.menu_id))
      }
      self.populateCharge(JSON.parse(node.dataset.charges))
    },
    methods: {
      setCredit: function(credit) {
        const self = this
        Rails.ajax({
          url: `/user/set_credit?order_id=${self.order.id}&pending_credit_id=${credit.id}`,
          type: 'GET',
          success: function() {
            self.selected_credit = credit.id
            credit.order_id = self.order.id
          }
        })
      },
      getRightPosition: function() {
        if (this.sidebar_shown) {
          return 30
        } else {
          return 2
        }
      },
      addItem: function(item, quantity) {
        const self = this;
        const item_id = item.id;
        const order = self.order
  
        let found = 0
        for (let menus_order of order.menus_orders_attributes) {
          if (menus_order.menu_id === item_id) {
            found++
            menus_order.quantity = quantity
            Rails.ajax({
              url: `/user/orders/store?menu_id=${item_id}&quantity=1&date=${self.order.placed_on}`,
              type: 'GET',
              success: function(response) {
                self.populateCharge(response)
              }
            })
          }
        }
  
        if (found === 0) {
          order.menus_orders_attributes.push({
            id: null,
            menu_id: item.id,
            quantity: quantity,
            add_ons: []
          })
          Rails.ajax({
            url: `/user/orders/store?menu_id=${item_id}&quantity=1&date=${self.order.placed_on}`,
            type: 'GET',
            success: function(response) {
              self.populateCharge(response)
            }
          })
          return;
        }
      },
      removeItem: function(item, quantity) {
        const self = this;
        const item_id = item.id;
        const order = self.order
        for (let [
          index,
          menus_order
        ] of order.menus_orders_attributes.entries()) {
          if (menus_order.menu_id === item_id) {
            menus_order.quantity = quantity;
            if (quantity === 0) {
              order.menus_orders_attributes.splice(index, 1);
            }
            Rails.ajax({
              url: `/user/orders/remove?menu_id=${item_id}&quantity=1&date=${self.order.placed_on}`,
              type: 'GET',
              success: function(response) {
                self.populateCharge(response)
              }
            })
            return;
          }
        }
      },
      removeAddOn: function(add_on_id, item) {
        const self = this
        const add_id = String(add_on_id)
        for (let menus_order of self.order.menus_orders_attributes) {
          if (menus_order.menu_id === item.id && menus_order.add_ons.includes(add_id)) {
            const index = menus_order.add_ons.indexOf(add_id);
            menus_order.add_ons.splice(index, 1);
            Rails.ajax({
              url:  `/user/orders/remove?date=${self.order.placed_on}&menu_id=${item.id}&add_on_id=${add_id}`,
              type: 'GET',
              success: function(response) {
                self.populateCharge(response)
              }
            })
          }
        }
      },
      addAddOn: function(add_on_id, item) {
        const self = this
        const add_id = String(add_on_id)
        for (let menus_order of self.order.menus_orders_attributes) {
          if (menus_order.menu_id === item.id && !menus_order.add_ons.includes(add_id)) {
            menus_order.add_ons.push(add_id)
            Rails.ajax({
              url:  `/user/orders/store?date=${self.order.placed_on}&menu_id=${item.id}&add_on_id=${add_on_id}`,
              type: 'GET',
              success: function(response) {
                self.populateCharge(response)
              }
            })
          }
        }
      },
      populateCharge: function(response) {
        const self = this
        self.tax = response.tax
        self.sub_total = response.sub_total
        self.excess = response.excess
        self.total = response.total
        self.shipping_fee = response.shipping_fee
      },
      saveOrder: function() {
        const self = this
        let url = `/user/orders/persist?order_id=${self.order.id}`

        if (self.order.status == 'template') {
          url = `/user/orders/persist_template?order_id=${self.order.id}`
        }

        Rails.ajax({
          url: url,
          type: "GET"
        })
      }
    }
  });
}