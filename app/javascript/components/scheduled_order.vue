<template>
  <div>
    <div class="row">
      <div class="col-5 mb-4">
        <input type="text" v-model="search_term" icon="search" class="form-control" placeholder="Search menu.." @input="$emit('input', search_term)"/>
      </div>
    </div>
    <vue-tabs @tab-change="handleTabChange">
      <v-tab v-for="(date, index) in dates" :title="date | to_dddd" v-bind:key="date">
        <div :id="`day_${index++}`" class="tab_pane mt-3">
          <div class="row">
            <div class="col meals__container" id="meals-tab-container">
              <items
                v-bind:menu_categories="menu_categories"
                v-bind:items="items"
                v-bind:prefix="`day_${index++}`"
                v-bind:date="date"
                v-bind:registration_form="registration_form">
              </items>
            </div>
          </div>
        </div>
      </v-tab>
    </vue-tabs>
  </div>
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
  data: () => {
    return {
      search_term: '',
      sortAsc: true,
      sortBy: "name",
    }
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
