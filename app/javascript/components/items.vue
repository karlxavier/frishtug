<template>
  <vue-tabs type="pills">
    <v-tab v-for="category in menu_categories" v-bind:key="`${category.id}-${prefix}`" :title="category.attributes.name">
      <ul class="nav justify-content-center my-4">
        <li class="nav-item mx-2">
          <strong class="text-uppercase">Legend</strong>
        </li>
        <li class="nav-item mx-2">
          <span class="fa fa-star diet-icons sugar-free mr-1"></span>
          Sugar Free
        </li>
        <li class="nav-item mx-2">
          <span class="fa fa-star diet-icons gluten-free mr-1"></span>
          Gluten Free
        </li>
        <li class="nav-item mx-2">
          <span class="fa fa-star diet-icons carb-free mr-1"></span>
          Carb Free
        </li>
        <li class="nav-item mx-2">
          <span class="fa fa-star diet-icons may-contain-allergens mr-1"></span>
          May Contain Allergens
        </li>
      </ul>
      <div class="row" :id="`${category.id}`">
        <div class="container-fluid">
          <div class="row">
            <div class='card col-12 col-custom-255 px-0 border-0 mb-4 mt-1 mr-4'
              v-for="item in items[category.attributes.name]" v-bind:key="`${item.id}-${prefix}`">
              <img :src="getImageUrl(item)" class="card-img-top" width="255" height="175">
              <div class="card-body px-0 py-1">
                <h5 class="card-title mb-0 font-family-montserrat">
                  {{ item.attributes.name }}
                </h5>
                <div class="row">
                  <div class="col-5">
                    <p class="card-text">
                      <small class="text-muted">
                        {{ item.attributes.price | to_currency }} / {{ item.attributes.unit.name }}
                      </small>
                    </p>
                  </div>
                  <div class="col cart-controls">
                    <a href="javascript:void(0)"
                      class="ctrl-btns btn btn-brown meal-ctrl-btns-minus rounded-0 disabled cart-controls__remove"
                      :data-value="menuCartValue(item)"
                      data-control="remove"
                      :data-control-target="`.meal-counter__${item.id}__${prefix}`"
                      :data-control-type="`${prefix}`">
                      -
                    </a>
                    <span :class="`meal-counter meal-counter__${item.id}__${prefix}`">
                      0
                    </span>
                    <a href="javascript:void(0)"
                      class="ctrl-btns btn btn-brown meal-ctrl-btns-minus rounded-0 cart-controls__remove"
                      :data-value="menuCartValue(item)"
                      data-control="add"
                      :data-control-target="`.meal-counter__${item.id}__${prefix}`"
                      :data-control-type="`${prefix}`">
                      +
                    </a>
                  </div>
                </div>
                <div class="row">
                  <div class="col">
                    <ul
                    :class="`list-unstyled d-none meal-counter__${item.id}__${prefix}__add_ons`">
                      <li v-for="add_on in item.meta.add_ons"
                        v-bind:key="`${add_on.id}-${prefix}`">
                        <label :for="`add_on_${add_on.id}__${prefix}`">
                          <input type="checkbox"
                          :name="add_on.name"
                          :id="`add_on_${add_on.id}__${prefix}`"
                          :value="add_on.id"
                          :data-value="createAddOnValue(add_on)"
                          data-type="add_ons"
                          :data-add-on-for="item.id"
                          :data-control-type="`${prefix}`"
                          >
                          {{ add_on.name }}
                        </label>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
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
    VTab
  },
  props: {
    items: { type: Object, required: true },
    menu_categories: { type: Array, required: true },
    prefix: { type: String, required: true }
  },
  methods: {
    getImageUrl: function(item) {
      const asset = item.attributes.asset
      if(asset === null) { return null }
      if(asset.hasOwnProperty('image')) {
        return asset.image.card.url;
      }
    },
    createAddOnValue: function(add_on) {
      const obj = {
        id: add_on.id,
        name: add_on.name,
        price: add_on.price
      }
      return JSON.stringify(obj)
    },
    menuCartValue: function(item) {
      const obj = {
        id: item.id,
        name: item.attributes.name,
        price: item.attributes.price,
        quantity: 1,
        tax: item.attributes.tax,
        add_ons: []
      }
      return JSON.stringify(obj)
    }
  }
}
</script>
