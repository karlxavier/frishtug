<template>
  <div>
    <div class="row meal-form__sidebar py-1dot35rem border-bottom-grey mx-0">
      <div class="col">
        <h5 class="text-uppercase font-size-18">Your Meals</h5>
      </div>
      <div class="col">
        <a href="javascript:void(0)" class="btn btn-outline-dark hide-sidebar" @click="$emit('on-sidebar-hide')">Hide Meals</a>
      </div>
    </div>
    <div id="sidebar-list" class="px-3 pb-4" style="height: calc(100vh - 10.5rem);overflow: hidden;overflow-y: auto;">
      <div class="order--list--container mt-4" v-if="order">
        <div v-for="item in order.menus_orders_attributes" :key="item.menu_id">
          <sidebar-items
            v-bind:item="item"
            v-bind:unreduce_items="unreduce_items"
            @add-item="addItem"
            @remove-item="removeItem"
            ></sidebar-items>
        </div>
        <div class="row clearfix">
          <div class="col-8">
            Tax
          </div>
          <div class="col-4">
            <span class="float-right">
              {{ tax | to_currency }}
            </span>
          </div>
        </div>
      </div>
      <hr>

      <div class="row clearfix">
        <div class="col">
          <span>Sub Total</span>
        </div>
        <div class="col">
          <span class="float-right">
            {{ sub_total | to_currency }}
          </span>
        </div>
      </div>

      <div class="row clearfix" v-show="shipping_fee > 0">
        <div class="col">
          <span>Shipping Fee</span>
        </div>
        <div class="col">
          <span class="float-right">
            {{ shipping_fee | to_currency }}
          </span>
        </div>
      </div>

      <div class="row clearfix">
        <div class="col">
          <strong>Total</strong>
        </div>
        <div class="col">
          <strong class="float-right">
            {{ total | to_currency }}
          </strong>
        </div>
      </div>

      <div class="warnings">
        <small class="alert alert-warning d-flex" style="font-size: 9px; width: 100%;" v-if="has_excess">
          <i class="fa fa-exclamation-circle font-size-24 pr-1" aria-hidden="true"></i>
          You have exceeded your plan limit of $ {{ plan.limit }}.
          Once you finalize your order you will need to pay the extra charges at the Pending Charges link in your dashboard.
        </small>

        <small class="alert alert-info d-flex" style="font-size: 10px; width: 100%;" v-if="has_remaining_credits">
          <i class="fa fa-info-circle font-size-24 pr-1" aria-hidden="true"></i>
          Order not finished, because you still have {{ remaining_credits | to_currency }} credits available.
        </small>
      </div>

      <div class="pending_credits_notice">
        <slot name="pending_credit"></slot>
      </div>

      <div class="row mt-4">
        <div class="col">
          <a href="javascript:void(0)" class="btn btn-brown btn--save-meal-plan btn-block" @click="$emit('on-save-meal')">
            Save Meal Plan
          </a>
        </div>
      </div>

      <slot name="undo_and_cancel"></slot>
    </div>
  </div>
</template>

<script>
import swal from "sweetalert2";
import moment from "moment";
import toCurrency from "../../packs/lib/to_currency";
import Money from "../../packs/lib/money";
import SidebarItems from "./sidebar_items";
export default {
  components: {
    SidebarItems
  },
  props: [
    "order",
    "unreduce_items",
    "tax",
    "shipping_fee",
    "sub_total",
    "total",
    "excess"
  ],
  data: () => {
    return {
      plan: {}
    }
  },
  filters: {
    to_currency: toCurrency,
    to_dddd: date => moment(date).format("dddd")
  },
  computed: {
    remaining_credits: function() {
      const sub = Money.$cents(this.sub_total)
      const limit = Money.$cents(this.plan.limit)
      return Money.$dollar(limit - sub)
    },
    has_excess: function() {
      if(this.plan.interval !== 'month') { return false }
      return this.excess > 0
    },
    has_remaining_credits: function() {
      if(this.plan.interval !== 'month') { return false }
      return this.sub_total >= Number(this.plan.minimum_credit_allowed) && this.remaining_credits > 0
    }
  },
  mounted: function() {
    const self = this;

    Rails.ajax({
      url: "/user/plans",
      type: "GET",
      success: function(response) {
        self.plan = response.data;
      }
    });

    const scroller = function() {
      let cartSidebar = document.querySelector(".meal-sidebar");
      var y = window.pageYOffset;

      const positionElement = el => {
        if (el) {
          el.classList.add("position-fixed");
          el.style.marginTop = "7rem";
        }
      };

      const removePositioning = el => {
        if (el) {
          el.classList.remove("position-fixed");
          el.style.marginTop = "0";
        }
      };

      if (y >= 90) {
        positionElement(cartSidebar);
      } else {
        removePositioning(cartSidebar);
      }
    };

    window.addEventListener("scroll", scroller);
  },
  methods: {
    addItem: function(item, quantity) {
      const new_item = item
      new_item.id = item.menu_id
      this.$emit('add-item', new_item, quantity)
    },
    removeItem: function(item, quantity) {
      const new_item = item
      new_item.id = item.menu_id
      this.$emit('remove-item', new_item, quantity)
    }
  }
};
</script>

<style>
  ul.nav.nav-pills {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
  }

  a.tabs__link {
    color: #252525;
    border: 1px solid #e1e1e1;
    border-radius: 0 !important;
    background: transparent !important;
  }

  a.active_tab.tabs__link {
    color: #fff !important;
    background: #582D11 !important;
  }

  .vue-tabs .nav-pills > li {
    margin: 0.5rem 1rem;
  }
</style>
