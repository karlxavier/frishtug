<template>
  <div class="row" v-show="menu_categories">
    <div class="col meals__container" id="meals-tab-container" v-if="checkObject(items)">
      <items
        v-bind:menu_categories="menu_categories"
        v-bind:items="items"
        v-bind:prefix="'single'"
        v-bind:date="dates[0]"
        v-bind:registration_form="registration_form">
      </items>
    </div>
    <div v-else>
      <i class="fa fa-spinner fa-spin"></i> Loading Meals...
    </div>
  </div>
</template>

<script>
import Items from './items'
export default {
  components: {
    Items
  },
  props: {
    registration_form: { type: Object, required: true },
    menu_categories: { type: Array },
    items: { type: Object },
    dates: { type: Array }
  },
  methods: {
    checkObject: function(obj) {
      return Object.keys(obj).length > 0
    }
  }
}
</script>
