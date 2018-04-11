<template>
  <div>
    <div class="row justify-content-center mb-3">
      <div class="col-8 text-center">
        <a href="javascript:void(0)"
          v-on:click="$emit('on-calendar-change', calendar.prev_month)"
          v-if="index === 0">
          <i class="fa fa-angle-left" aria-hidden="true"></i>
        </a>
        <span class="mx-4">{{ calendar.month }}</span>
        <a href="javascript:void(0)"
          v-on:click="$emit('on-calendar-change', calendar.prev_month)"
          v-if="index === 1">
          <i class="fa fa-angle-right" aria-hidden="true"></i>
        </a>
      </div>
    </div>
    <table :class="`${calendar.month} calendar table table-bordered table-sm`">
      <thead>
        <th class="text-center">S</th>
        <th class="text-center">M</th>
        <th class="text-center">T</th>
        <th class="text-center">W</th>
        <th class="text-center">T</th>
        <th class="text-center">F</th>
        <th class="text-center">S</th>
      </thead>
      <tbody>
        <tr v-for="(days, index2) in calendar.days" v-bind:key="`${index2}-calendar-week`">
          <td v-for="(date, index3) in days" v-bind:key="`${index3}-calendar-day`">
            <span v-if="isBlockDate(date)" class="disabled">
              {{ showDate(date, calendar.month) }}
            </span>
            <span v-else-if="showDate(date, calendar.month) === null"></span>
            <a
            href="javascript:void(0)"
            v-on:click="$emit('on-select-day', date)"
            :class="isActiveDate(date)"
            v-else>
              {{ showDate(date, calendar.month) }}
            </a>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import moment from "moment";
export default {
  data: function() {
    return {
      current_date: ''
    }
  },
  props: {
    registration_form: { type: Object, required: true },
    delivery_dates: { type: Array, required: true },
    calendar: { type: Object, required: true },
    index: { type: Number, required: true },
    plan: { type: Object, required: true }
  },
  mounted: function() {
    const self = this
    Rails.ajax({
      url: '/api/v1/server_time',
      type: 'GET',
      success: function(response) {
        self.current_date = response.data
      }
    })
  },
  methods: {
    showDate: function(date, month) {
      const theMonth = moment(month, "MMMM YYYY")
        .toDate()
        .getMonth();
      const newDate = moment(date).toDate();
      if (theMonth === newDate.getMonth()) {
        return newDate.getDate();
      } else {
        return null;
      }
    },
    isActiveDate: function(date) {
      const active = `date-${date} active calendar__date_item`;
      if (this.delivery_dates.includes(date)) {
        return active;
      }

      return `date-${date} calendar__date_item`;
    },
    isBlockDate: function(date) {
      const self = this;
      const currentDate = moment(self.current_date).toDate();
      const theDate = moment(date).toDate();

      if (!self) {
        return false;
      }

      const isSunday = date => {
        const sunday = 0;
        return date.getDay() === sunday;
      };

      const isFriday = date => {
        const friday = 5;
        return date.getDay() === friday;
      };

      const isMondayToFridaySchedule = () => {
        if (self.plan.interval !== "month") return false;
        return self.registration_form.schedule === "monday_to_friday";
      };

      const isSundayToThursdaySchedule = () => {
        if (self.plan.interval !== "month") return false;
        return self.registration_form.schedule === "sunday_to_thursday";
      };

      if (isMondayToFridaySchedule()) {
        if (isSunday(theDate)) return true;
      } else if (isSundayToThursdaySchedule()) {
        if (isFriday(theDate)) return true;
      }

      const isYesterdaysDate = theDate.getTime() < currentDate.getTime();
      if (isYesterdaysDate) {
        return true;
      }

      const isSameDate = theDate.getTime() === currentDate.getTime();
      if (isSameDate) {
        return true;
      }

      const addOne = date => {
        date.setDate(date.getDate() + 1);
        return date.getTime();
      };

      const isDatePlusOne = theDate.getTime() === addOne(currentDate);
      if (isDatePlusOne) {
        return self.is_past;
      }

      return !self.isNotSaturday(date);
    },
    isNotSaturday: function(date) {
      const newDate = moment(date).toDate();
      return newDate.getDay() < 6;
    }
  }
}
</script>
