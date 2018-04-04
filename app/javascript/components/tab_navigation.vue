<template>
  <ul class="nav nav-tabs" id="tab-navigation" role="tablist">
    <li class="nav-item" v-for="num in count" v-bind:key="`tab-for-${num}`">
      <a
        :class="isActiveIndex(num)"
        :id="`day-${num}-tab`"
        data-toggle="tab"
        :href="`#day_${num}`"
        role="tab"
        :aria-controls="`day_${num}`"
        :aria-selected="num === activeIndex"
        @click="setActiveIndex(num)"
      >
        {{ date_names[num - 1] }}
      </a>
    </li>
  </ul>
</template>

<script>
  export default {
    data: function() {
      return {
        count: 5,
        activeIndex: 1,
      }
    },
    props: ['date_names'],
    methods: {
      isActiveIndex: function(index) {
        if (this.activeIndex === index) {
          return "nav-link active"
        } else {
          return "nav-link"
        }
      },
      setActiveIndex: function(index) {
        this.activeIndex = index
      }
    }
  }
</script>
