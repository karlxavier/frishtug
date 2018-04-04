<template>
  <div class="row">
    <div class="col meals__container" id="meals-tab-container">
      <items
        v-bind:menu_categories="menu_categories"
        v-bind:items="items"
        v-bind:prefix="'single'">
      </items>
    </div>
  </div>
</template>

<script>
export default {
  components: {
    "items": () => import('./items.vue')
  },
  props: {
    menu_categories: { type: Array },
    items: { type: Object }
  }
}
</script>
