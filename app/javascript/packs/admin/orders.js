import VueTabs from 'vue-nav-tabs';
import Vue from 'vue/dist/vue.esm';
import TodaysList from '../../components/admin_backend/todays_list';
import swal from 'sweetalert2';

// Components
Vue.use(VueTabs)

const el = document.querySelector('#frishtug_orders')

const vm = new Vue({
  el: el,
  components: {
    TodaysList
  },
  data: {
    today: [],
    in_transit: [],
    completed: [],
    page: 2,
    date: el.dataset.date
  },
  mounted: function() {
    const self = this
    Rails.ajax({
      url: `/admin/dashboard.json?date=${self.date}`,
      type: 'GET',
      success: function(response) {
        self.today = response
      }
    })
  },
  methods: {
    viewMore: function() {
      const self = this
      const counter = self.page++
      Rails.ajax({
        url: `/admin/dashboard.json?date=${self.date}&page=${counter}`,
        type: 'GET',
        success: function(response) {
          if (response.length > 0) {
            self.today.push(...response)
          } else {
            swal({
              type: "success",
              title: "The End",
              text: "Youve reach the end.",
              confirmButtonText: "Ok",
              confirmButtonColor: "#582D11",
              confirmButtonClass: "btn btn-brown text-uppercase",
              buttonsStyling: false
            })
          }
        }
      })
    }
  }
})