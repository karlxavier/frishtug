import VueTabs from 'vue-nav-tabs';
import Vue from 'vue/dist/vue.esm';
import TodaysList from '../../components/admin_backend/todays_list';
import swal from 'sweetalert2';

// Components
Vue.use(VueTabs)

const el = document.querySelector('#frishtug_orders')
let meal = []
let location = []

if (el.dataset.meal) {
  meal = el.dataset.meal.split(',')
}

if (el.dataset.location) {
  location = el.dataset.location.split(',')
}

const vm = new Vue({
  el: el,
  components: {
    TodaysList
  },
  data: {
    today: [],
    in_transit: [],
    completed: [],
    page: 1,
    date: el.dataset.date,
    current_date: el.dataset.currentDate,
    meal: meal,
    location: location
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

    const pollOrders = () => {
      let date = self.current_date
      let counter = null
      const meal_param = self.meal.length > 0 ? `&meal=${self.meal.join(',')}` : ""
      const location_param = self.location.length > 0 ? `&location=${self.location.join(',')}` : ""

      if (self.date !== "") { date = self.date; }
      Rails.ajax({
        url: `/admin/scanovators.json?date=${date}&page=${self.page}${meal_param}${location_param}`,
        type: 'GET',
        success: function(response) {
          self.today = response
        }
      })
    }

    setInterval(pollOrders, 10000);
  },
  methods: {
    viewMore: function() {
      const self = this
      self.page += 1
      const counter = self.page
      const meal_param = self.meal.length > 0 ? `&meal=${self.meal.join(',')}` : ""
      const location_param = self.location.length > 0 ? `&location=${self.location.join(',')}` : ""
      Rails.ajax({
        url: `/admin/dashboard.json?date=${self.date}&page=${counter}${meal_param}${location_param}`,
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