import VueTabs from 'vue-nav-tabs'
import Vue from 'vue/dist/vue.esm'
import swal from 'sweetalert2'

// Components
Vue.use(VueTabs)

const el = document.querySelector('#frishtug_orders')

const orders = new Vue({
  el: el,
  data: {

  },
  methods: {
    showDetails: function(id) {
      const viewBtn = document.querySelector(`#view-${id}`)
      const div = document.querySelector(`#order-${id}`)
      div.classList.remove('d-none')
      div.classList.add('show')
      viewBtn.classList.add('d-none')
    },
    hideDetails: function(id) {
      const viewBtn = document.querySelector(`#view-${id}`)
      const div = document.querySelector(`#order-${id}`)
      div.classList.remove('show')
      div.classList.add('d-none')
      viewBtn.classList.remove('d-none')
    }
  }
})