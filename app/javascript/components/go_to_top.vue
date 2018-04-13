<template>
  <a @click="goTop" class="go_to_top" v-show="show" :style="`right: ${right}rem`">
    <i class="fa fa-chevron-up"></i>
  </a>
</template>


<script>
export default {
  props: ['right'],
  data: function() {
    return {
      show: false
    }
  },
  methods: {
    goTop: function() {
      $("html, body").animate({ scrollTop: 0 }, 600);
    }
  },
  mounted() {
    const self = this
    const showScrollTopBtn = () => {
      if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
          self.show = true
      } else {
          self.show = false
      }
    }

    window.onscroll = showScrollTopBtn
  }
}
</script>

<style>
  .go_to_top {
    width: 50px;
    height: 50px;
    background: rgb(88, 45, 17);
    position: fixed;
    bottom: 20px;
    z-index: 99;
    border: none;
    outline: none;
    cursor: pointer;
    padding: 0.6rem 1rem;
    border-radius: 10px;
    font-size: 18px;
    text-decoration: none;
  }

  .go_to_top > i {
    color: white;
  }
</style>

