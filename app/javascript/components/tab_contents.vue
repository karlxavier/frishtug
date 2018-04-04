<template>
  <div class="tab-content" id="myTabContent">
    <template v-for="num in count">
      <div :class="isActivePanel(num)" :id="`day_${num}`" role="tabpanel" :aria-labelledby="`day-${num}-tab`" v-bind:key="`tab-content-day-${num}`">
        <div class="row">
          <div class="col meals__container" id="meals-tab-container">
            <items
              v-bind:menu_categories="menu_categories"
              v-bind:items="items"
              v-bind:prefix="`day_${num}`">
            </items>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import Items from './items.vue'
export default {
  components: {
    Items
  },
  props: {
    menu_categories: { type: Array },
    items: { type: Object }
  },
  data: function() {
    return {
      count: 5,
      activeTab: 1
    }
  },
  methods: {
    isActivePanel: function(index) {
      if (this.activeTab === index) {
        return "tab-pane fade show active"
      } else {
        return "tab-pane"
      }
    }
  }
}
</script>

