import Vue from "vue/dist/vue.esm"
import VueResource from "vue-resource"

Vue.use(VueResource)
Vue.http.headers.common["X-CSRF-Token"] = document
  .querySelector('meta[name="csrf-token"]')
  .getAttribute("content");

const mountVm = () => {
  const form = document.querySelector("#client_orders_form");

  if (!form) {
    return;
  }

  const order = JSON.parse(form.dataset.order);
  const menus_orders_attributes = JSON.parse(form.dataset.menusOrdersAttributes);
  menus_orders_attributes.forEach(menu_order => (menu_order._destroy = null));
  order.menus_orders_attributes = menus_orders_attributes;

  const clientOrders = new Vue({
    el: form,
    data: {
      order: order,
      add_ons: []
    },
    mounted: function() {
      const self = this;
      self.order.menus_orders_attributes.forEach(menu => {
        self.getAddOns(menu.menu_id);
      });
    },
    methods: {
      hasAddOns: function(menu_id) {
        return (
          this.add_ons.filter(add_on => add_on.id === menu_id).length > 0
        );
      },
      addonsForMenu: function(menu_id) {
        const addOns = this.add_ons.filter(add_on => add_on.id === menu_id);
        return addOns.length > 0 ? addOns[0].add_ons : [];
      },
      getAddOns: function(menu_id) {
        const self = this;
        this.$http.get(`/admin/add_ons?id=${menu_id}`).then(response => {
          const body = response.body;
          if (body.status === "success") {
            self.add_ons.push({
              id: menu_id,
              add_ons: JSON.parse(body.add_ons)
            });
          }
        });
      },
      addMenuOrder: function() {
        this.order.menus_orders_attributes.push({
          id: null,
          menu_id: null,
          quantity: 1,
          add_ons: [],
          _destroy: null
        });
      },
      deleteMenuOrder: function(index) {
        const menus_order = this.order.menus_orders_attributes[index];
        if (!menus_order.id) {
          this.order.menus_orders_attributes.splice(index, 1);
        } else {
          menus_order._destroy = "1";
        }
      },
      saveOrders: function() {
        this.$http
          .put(`/admin/orders/${this.order.id}`, { order: this.order })
          .then(
            response => {
              if (response.body.status === "success") {
                swal({
                  type: "success",
                  title: "Successful!",
                  text: "Orders updated successfully",
                  confirmButtonText: "Done",
                  confirmButtonColor: "#582D11",
                  confirmButtonClass: "btn btn-matterhorn text-uppercase",
                  buttonsStyling: false
                });
              }
            },
            response => {
              console.warn(response);
            }
          );
      }
    }
  });
}
mountVm()
window.mountVm = mountVm