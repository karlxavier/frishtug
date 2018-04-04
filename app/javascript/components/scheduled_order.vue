<template>
  <vue-tabs @tab-change="handleTabChange">
    <v-tab :title="date_names[0]">
      <div id="day_1" class="tab_pane mt-3">
        <div class="row">
          <div class="col meals__container" id="meals-tab-container">
            <items
              v-bind:menu_categories="menu_categories"
              v-bind:items="items"
              v-bind:prefix="'day_1'">
            </items>
          </div>
        </div>
      </div>
    </v-tab>
    <v-tab :title="date_names[1]">
      <div id="day_2" class="tab_pane mt-3">
        <div class="row">
          <div class="col meals__container" id="meals-tab-container">
            <items
              v-bind:menu_categories="menu_categories"
              v-bind:items="items"
              v-bind:prefix="'day_2'">
            </items>
          </div>
        </div>
      </div>
    </v-tab>
    <v-tab :title="date_names[2]">
      <div id="day_3" class="tab_pane mt-3">
        <div class="row">
          <div class="col meals__container" id="meals-tab-container">
            <items
              v-bind:menu_categories="menu_categories"
              v-bind:items="items"
              v-bind:prefix="'day_3'">
            </items>
          </div>
        </div>
      </div>
    </v-tab>
    <v-tab :title="date_names[3]">
      <div id="day_4" class="tab_pane mt-3">
        <div class="row">
          <div class="col meals__container" id="meals-tab-container">
            <items
              v-bind:menu_categories="menu_categories"
              v-bind:items="items"
              v-bind:prefix="'day_4'">
            </items>
          </div>
        </div>
      </div>
    </v-tab>
    <v-tab :title="date_names[4]">
      <div id="day_5" class="tab_pane mt-3">
        <div class="row">
          <div class="col meals__container" id="meals-tab-container">
            <items
              v-bind:menu_categories="menu_categories"
              v-bind:items="items"
              v-bind:prefix="'day_5'">
            </items>
          </div>
        </div>
      </div>
    </v-tab>
  </vue-tabs>
</template>

<script>
import { VueTabs, VTab } from "vue-nav-tabs";
export default {
  components: {
    VueTabs,
    VTab,
    "items": () => import('./items.vue')
  },
  props: {
    menu_categories: { type: Array },
    items: { type: Object },
    date_names: {
      type: Array,
      default: () => ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    }
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
