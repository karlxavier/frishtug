<template>
  <div>
    <div class="row">
      <div class="col-5 mb-4">
        <input type="text" v-model="search_term" icon="search" class="form-control" placeholder="Search menu.." @input="$emit('input', search_term)"/>
      </div>
    </div>
    <div class="row" v-show="menu_categories">
    <div class="col meals__container" id="meals-tab-container">
      <items
        v-bind:menu_categories="menu_categories"
        v-bind:items="items"
        v-bind:prefix="'single'"
        v-bind:date="dates[0]"
        v-bind:registration_form="registration_form">
      </items>
    </div>
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
  }
}
</script>
