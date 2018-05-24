<template>
  <div class="meal-sidebar">
    <div class="meal-sidebar__header">
      <div class="col-8">
        <h5 class="text-uppercase font-size-18">Your Meals</h5>
      </div>
      <div class="col-4">
        <a href="javascript:void(0)" class="btn btn-outline-dark btn-sm font-size-12" @click="$emit('on-sidebar-hide')">Hide Meals</a>
      </div>
    </div>
    <div class="order-field meal-sidebar__body">
      <div class="col">
        <div class="order-list">
        
          <div class="mt-3" v-if="order">
            <h6 class="text-upperclass order-title mb-0"
              :id="order.placed_on | to_dddd">
              {{ order.placed_on | to_dddd }}
            </h6>
            <div>
              {{ order }}
            </div>
          </div>
          
        </div>
      </div>
    </div>
    <div class="meal-sidebar__footer">
      <div class="col">
        <a href="javascript:void(0)" class="btn btn-brown btn--save-meal-plan btn-block" @click="$emit('on-save-meal')">
          Save Meal Plan
        </a>
      </div>
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
  props: {
    order: { type: Object, required: false },
    unreduce_items: { type: Array, required: false  }
  },
  data: () => {
    return {
      tax: null,
      plan: {}
    }
  },
  filters: {
    to_currency: toCurrency,
    to_dddd: date => moment(date).format("dddd")
  },
  mounted: function() {
    const self = this;
    Rails.ajax({
      url: "/api/v1/taxs",
      type: "GET",
      success: function(response) {
        self.tax = parseFloat(response.data);
      }
    });

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
  methods: {}
};
</script>
