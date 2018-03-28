import Vue from "vue/dist/vue.esm";
import VueResource from "vue-resource";

Vue.use(VueResource);

const clientsApp = new Vue({
  el: document.querySelector('#clients-app'),
  data: {
    current_order_id: null
  },
  methods: {
    showModal: function(order_id) {
      this.current_order_id = order_id
      Rails.ajax({
        url: `/admin/orders/${order_id}.js`,
        type: 'GET'
      })
      $('#clients-modal-dialog').modal('show')
    },
    editOrder: function() {
      window.location = `/admin/orders/${this.current_order_id}/edit`
    }
  }
})
