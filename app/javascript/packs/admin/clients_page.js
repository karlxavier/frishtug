import Vue from "vue/dist/vue.esm";
import VueResource from "vue-resource";

Vue.use(VueResource);

const clientsApp = new Vue({
  el: document.querySelector('#clients-app'),
  data: {
    current_order_id: null,
    show_header: false,
    show_edit_btn: true
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
    revertBack: function() {
      this.show_edit_btn = true
      this.show_header = false
    },
    editOrder: function() {
      const self = this
      Rails.ajax({
        url: `/admin/orders/${self.current_order_id}/edit.js`,
        type: 'GET',
        success: () => {
          self.show_edit_btn = false;
          self.show_header = true;
        }
      })
    }
  }
})
