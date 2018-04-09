<template>
  <form-wizard step-size="xs" color="#562d07" ref="wizard">
    <h2 slot="title"></h2>
    <tab-content title="Plan" route="/user_registrations"></tab-content>
    <template slot="footer" scope="props">
      <wizard-button
        @click.native="props.nextTab()"
        class="wizard-footer-right d-none">
        Next Step
      </wizard-button>
    </template>
    <transition name="fade" mode="out-in">
      <router-view></router-view>
    </transition>
  </form-wizard>
</template>

<script>
import VueFormWizard from "vue-form-wizard";
export default {
  components: {
    VueFormWizard
  }
}
</script>

