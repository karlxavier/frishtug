import Vue from "vue/dist/vue.esm"
import VueResource from "vue-resource"

Vue.use(VueResource)
Vue.http.headers.common["X-CSRF-Token"] = document
  .querySelector('meta[name="csrf-token"]')
  .getAttribute("content");

const form = document.querySelector("#client_orders_form")
const order = JSON.parse(form.dataset.order)
const menus_orders_attributes = JSON.parse(form.dataset.menusOrdersAttributes)
menus_orders_attributes.forEach(menu_order => (menu_order._destroy = null));
order.menus_orders_attributes = menus_orders_attributes

const clientOrders = new Vue({
  el: form,
  data: {
    order: order
  },
  methods: {
    addMenuOrder: function() {
      this.order.menus_orders_attributes.push({
        id: null,
        menu_id: null,
        quantity: 0,
        _destroy: null
      });
    },
    deleteMenuOrder: function(index) {
      const menus_order = this.order.menus_orders_attributes[index]
      if (!menus_order.id) {
        this.order.menus_orders_attributes.splice(index, 1);
      } else {
        menus_order._destroy = "1";
      }
    },
    saveOrders: function() {
      this.$http.put(`/admin/orders/${this.order.id}`, { order: this.order })
        .then(response => {
          console.log(response)
        }, response => {
          console.warn(response)
        })
    }
  }
});
