import Vue from "vue/dist/vue.esm";
import Items from "../../components/user_backend/items";
import Sidebar from "../../components/user_backend/sidebar";
import VueLazyload from "vue-lazyload";

Vue.use(VueLazyload);

const vm = new Vue({
  el: "#orders-form",
  data: () => {
    return {
      order: {
        id: null
      },
      items: {},
      schedule: null,
      unreduce_items: []
    }
  },
  components: {
    Items,
    Sidebar
  },
  mounted() {
    const self = this
    const node = document.querySelector("#orders-form")
    if (node) {
      self.order = JSON.parse(node.dataset.orders)
      self.schedule = JSON.parse(node.dataset.schedule)
      Rails.ajax({
        url: `/user/orders/${self.order.id}`,
        type: 'GET',
        success: function(response) {
          self.order = response.data
          self.order.menus_orders_attributes = []
        }
      })

      Rails.ajax({
        url: '/api/v1/items',
        type: 'GET',
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
      })
    }
  },
  methods: {
    addItem: function(item, quantity) {
      const self = this;
      const item_id = item.id;
      const order = self.order

      let found = 0
      for (let menus_order of order.menus_orders_attributes) {
        if (menus_order.menu_id === item_id) {
          found++
          menus_order.quantity = quantity
        }
      }

      if (found === 0) {
        order.menus_orders_attributes.push({
          menu_id: item.id,
          quantity: quantity,
          add_ons: []
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
          return;
        }
      }
    },
    removeAddOn: function(add_on_id, item) {
      const self = this
      for (let menus_order of self.order.menus_orders_attributes) {
        if (menus_order.menu_id === item.id && menus_order.add_ons.includes(add_on_id)) {
          const index = menus_order.add_ons.indexOf(add_on_id);
          menus_order.add_ons.splice(index, 1);
        }
      }
    },
    addAddOn: function(add_on_id, item) {
      const self = this
      for (let menus_order of self.order.menus_orders_attributes) {
        if (menus_order.menu_id === item.id && !menus_order.add_ons.includes(add_on_id)) {
          menus_order.add_ons.push(add_on_id)
        }
      }
    },
  }
})