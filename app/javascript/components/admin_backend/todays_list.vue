<template>
  <div class="container-fluid mt-4 <%= order.id %> admin_dashboard__order_list_item">
    <div class="row">
      <div class="col">
        <h5>
          {{ order.series_number }}
          <small class="text-muted">(placed on {{ placed_on }})</small>
          <span v-bind:class="badgeClass">
            {{ status }}
          </span>
        </h5>
      </div>
      <div class="col">
        Order #: {{ order.id }} &nbsp; Is Rollovered: {{ order.is_rollover }}
      </div>
    </div>
    <div class="row">
      <div class="col">
        <strong class="matterhorn-font-color">
          {{ full_name }} <small class="pl-1 text-muted">{{ email }}</small>
        </strong>
        <p>{{ address }}</p>
        <a href="javascript:void(0)" @click="shown = true" class="chocolate-font-color"  v-show="shown == false">
          View Order Details <i class="fa fa-angle-down"></i>
        </a>
      </div>
      <div class="col">
        <strong class="matterhorn-font-color">Notes</strong>
        <p>{{ order.remarks }}</p>
      </div>
    </div>
    <div class="row fade" :class="shown ? 'show':'d-none'">
      <div class="col-6">
        <todays-details :order="order" @on-hide-details="shown = false"></todays-details>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import TodaysDetails from './todays_details';
export default {
  props: ['order'],
  data: function() {
    return {
      shown: false
    };
  },
  components: {
    TodaysDetails
  },
  methods: {
    viewDetails: function(order) {
      this.$emit('on-view-details', order.id);
    }
  },
  computed: {
    badgeClass() {
      let klass = 'badge badge-pill font-size-12';
      if (this.order.status === 'processing') {
        return (klass += ' badge-success');
      }

      if (this.order.status === 'cancelled') {
        return (klass += ' badge-warning');
      }

      return (klass += ' badge-secondary');
    },
    status() {
      return this.order.status
        .toUpperCase()
        .split('_')
        .join(' ');
    },
    full_name() {
      return this.order.user.full_name;
    },
    email() {
      return `<${this.order.user.email}>`;
    },
    address() {
      return [
        this.order.user.address.line1,
        this.order.user.address.line2,
        this.order.user.address.front_door,
        this.order.user.address.city,
        this.order.user.address.state,
        this.order.user.address.zip_code
      ]
        .filter(Boolean)
        .join(', ');
    },
    placed_on() {
      return moment(this.order.updated_at).format('H:mm a');
    }
  }
};
</script>
