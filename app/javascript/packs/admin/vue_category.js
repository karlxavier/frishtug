import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  var el = document.querySelector('#new-menu-category')
  var menu_category = JSON.parse(el.dataset.menuCategory)
  var add_ons_attributes = JSON.parse(el.dataset.addOnsAttributes)
  add_ons_attributes.forEach( addon => { addon._delete = null })
  menu_category.add_ons_attributes = add_ons_attributes
  var form = new Vue({
    el: el,
    data: {
      menu_category: menu_category
    },
    methods: {
      addAddons: function() {
        this.menu_category.add_ons_attributes.push({
          id: null,
          name: null,
          _delete: null
        })
      },
      hideAddons: function(index) {
        let addons = this.menu_category.add_ons_attributes
        addons[index].id === 'null' ? addons[index]._delete = 1 : addons.splice(index, 1)
      }
    }
  })
  window.form
})
