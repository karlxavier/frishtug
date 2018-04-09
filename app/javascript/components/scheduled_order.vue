<template>
  <vue-tabs @tab-change="handleTabChange">
    <v-tab v-for="(date, index) in dates" :title="date | to_dddd" v-bind:key="date">
      <div :id="`day_${index++}`" class="tab_pane mt-3">
        <div class="row" v-if="checkObject(items)">
          <div class="col meals__container" id="meals-tab-container" v-if="items">
            <items
              v-bind:menu_categories="menu_categories"
              v-bind:items="items"
              v-bind:prefix="`day_${index++}`"
              v-bind:date="date"
              v-bind:registration_form="registration_form">
            </items>
          </div>
          <div v-else>
            <i class="fa fa-spinner fa-spin"></i> Loading Meals...
          </div>
        </div>
      </div>
    </v-tab>
  </vue-tabs>
</template>

<script>
import { VueTabs, VTab } from "vue-nav-tabs";
import Items from './items'
import moment from "moment"
export default {
  components: {
    VueTabs,
    VTab,
    Items
  },
  props: {
    registration_form: { type: Object, required: true },
    menu_categories: { type: Array },
    items: { type: Object },
    dates: { type: Array, required: true }
  },
  filters: {
    to_dddd: (date) => moment(date).format('dddd')
  },
  methods: {
    checkObject: function(obj) {
      return Object.keys(obj).length > 0
    },
    handleTabChange: function(tabIndex, newTab, oldTab) {
      this.scrollToView(`#${newTab.title}`)
    },
    scrollToView: function(target) {
      const el = document.querySelector(target);
      if (el) {
        const topPosition = el.offsetTop;
        $(".meal-sidebar__body").animate({ scrollTop: topPosition }, 600);
      }
    }
  }
}
</script>
