<template>
  <div>
    <div class="row justify-content-center align-items-center mt-4">
      <div class="col-12 col-md-6">
        <h4 class="text-center text-uppercase">
          Choose Delivery Day
        </h4>
        <p class="text-center" v-if="plan.interval !== 'month' ">
          Choose when you want your <strong>single breakfast order</strong> to be delivered.
        </p>
        <p class="text-center" v-else>
          Choose your schedule or pick a date in the calendar.
        </p>
      </div>
    </div>

    <div class="row justify-content-center my-4" v-if="plan.interval === 'month' ">
      <div class="col-4 text-center">
        <a href="javascript:void(0)" :class="`btn btn-brown-outline p-4 schedule-btns ${monday_to_friday_is_active}`"
          @click="setSchedule(earliest_monday, 'monday_to_friday')">
          Monday To Friday
        </a>
        <a href="javascript:void(0)" :class="`btn btn-brown-outline p-4 schedule-btns ${sunday_to_thursday_is_active}`"
          @click="setSchedule(earliest_sunday, 'sunday_to_thursday')">
          Sunday To Thursday
        </a>
      </div>
    </div>

    <div class="row justify-content-center mb-4">
      <div class="col-md-3" v-for="(calendar, index) in calendars" v-bind:key="`${index}--calendar`">
        <div class="calendar-errors"></div>
        <div class="calendar-container">
          <calendar
            v-bind:calendar="calendar"
            v-bind:index="index"
            v-bind:plan="plan"
            v-bind:registration_form="registration_form"
            @on-select-day="selectDay"
            @on-calendar-change="changeCalendar">
          </calendar>
        </div>
      </div>
    </div>

    <div class="row justify-content-center">
      <div class="col-md-4">
        <a href="javascript:void(0)" class="btn btn-brown btn-block text-uppercase" @click="verifySchedule">Continue To Payment</a>
      </div>
    </div>
  </div>
</template>

<script>
import Calendar from './calendar'
export default {
  components: {
    Calendar
  },
  props: {
    registration_form: { type: Object, required: true },
    plan: { type: Object, required: true },
    date: { type: Object, required: true }
  },
  data: () => {
    return {
      calendars: null,
      earliest_monday: null,
      earliest_sunday: null,
      monday_to_friday_is_active: null,
      sunday_to_thursday_is_active: null
    }
  },
  mounted: function() {
    const self = this;
    Rails.ajax({
      url: "/api/v1/calendar",
      type: "GET",
      success: function(response) {
        self.calendars = response;
      }
    });

    Rails.ajax({
      url: "/api/v1/earliest_dates",
      type: "GET",
      success: function(response) {
        self.earliest_monday = response.earliest_monday;
        self.earliest_sunday = response.earliest_sunday;
      }
    });
  },
  methods: {
    verifySchedule: function() {
      const self = this
      const message = self.plan.interval === 'month' ? 'schedule' : 'date'
      if (self.$store.state.selected_dates.length > 0) {
        self.$emit('next-tab')
      } else {
        swal("Opps...", `Please select a ${message}.`, "error");
        return;
      }
    },
    changeCalendar: function(date) {
      const self = this;
      Rails.ajax({
        url: `/api/v1/calendar?date=${date}`,
        type: "GET",
        success: function(response) {
          self.calendars = parsed;
        }
      });
    },
    selectDay: function(date) {
      const self = this;
      if (self.plan.interval === "month") {
        self.setSchedule(date, self.registration_form.schedule);
      } else {
        self.$store.commit('new_selected_dates', date)
        self.date.selected = date
        self.registration_form.orders = []
        self.registration_form.orders.push({
          order_date: date,
          menus_orders_attributes: []
        })
      }
    },
    setSchedule: function(date, schedule) {
      const self = this
      self.registration_form.schedule = schedule
      self.date.selected = date
      Rails.ajax({
        url: `/api/v1/selected_dates?date=${date}&schedule=${schedule}`,
        type: 'GET',
        success: function(response) {
          const errorEl = document.querySelector(".calendar-errors");
          if (response.status === "success") {
            errorEl.innerHTML = "";
            self.$store.commit('new_selected_dates', response.dates);
            const empty_orders = self.registration_form.orders.length === 0
            const size = self.$store.state.selected_dates.length
            if (empty_orders) {
              for (let i = 1; i <= size; i++) {
                self.registration_form.orders.push({
                  order_date: self.$store.state.selected_dates[i - 1],
                  menus_orders_attributes: []
                })
              }
            } else {
              self.registration_form.orders.forEach( (order, index) => {
                order.order_date = self.$store.state.selected_dates[index]
              })
            }
          } else {
            errorEl.innerHTML = "";
            const div = document.createElement("div");
            div.className = "alert alert-danger";
            div.innerHTML = `<strong>${response.message}</strong>`;
            errorEl.appendChild(div);
          }
        }
      })

      if (schedule === "monday_to_friday") {
        self.monday_to_friday_is_active = "active"
        self.sunday_to_thursday_is_active = ""
      }

      if (schedule === "sunday_to_thursday") {
        self.monday_to_friday_is_active = ""
        self.sunday_to_thursday_is_active = "active"
      }
    },
    nextTab: function() {
      console.log('test')
    }
  }
}
</script>

