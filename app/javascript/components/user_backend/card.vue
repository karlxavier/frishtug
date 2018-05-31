<template>
  <div class='card col-12 col-custom-255 px-0 border-0 mb-4 mt-1 mr-4'>
    <img v-lazy="imageUrl(item)" class="card-img-top" @click="$emit('on-image-click', item)" width="255" height="175" style="cursor: pointer;">
    <div class="card-body px-0 py-1">
      <h5 class="card-title mb-0 font-family-montserrat">
        {{ item.attributes.name }}
        <template v-for="diet in item.attributes.diet_categories">
          <span :class="dietClass(diet)" v-bind:key="diet.id"></span>
        </template>
      </h5>
      <div class="row" v-show="!!item.attributes.notes">
        <div class="col">
          <p class="card-text font-size-14 text-info">
            {{ item.attributes.notes }}
          </p>
        </div>
      </div>
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
            class="ctrl-btns btn btn-brown meal-ctrl-btns-minus rounded-0 cart-controls__remove"
            @click="removeItem(item, $event)"
            >
            -
          </a>
          <span class="meal-counter">
            {{ showCounter() }}
          </span>
          <a href="javascript:void(0)"
            class="ctrl-btns btn btn-brown meal-ctrl-btns-minus rounded-0 cart-controls__remove"
            :class="disable_add === true ? 'disabled' : null"
            @click="addItem(item, $event)">
            +
          </a>
        </div>
      </div>
      <div class="row">
        <div class="col" v-show="item.meta.add_ons.length > 0">
          <ul class="list-unstyled">
            <li v-for="add_on in item.meta.add_ons"
              v-bind:key="`${add_on.id}-${item.id}`">
              <label :for="`add_on_${add_on.id}_${item.id}`">
                <input type="checkbox"
                :name="add_on.name"
                :id="`add_on_${add_on.id}_${item.id}`"
                @click="addAddOn(add_on.id, item, $event)"
                >
                {{ add_on.name }}
              </label>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import toCurrency from "../../packs/lib/to_currency";
import NoImage from "../../packs/images/no-image.svg"
export default {
  filters: {
    to_currency: toCurrency
  },
  data: () =>{
    return {
      disable_add: false,
      counter: 0
    }
  },
  props: {
    item: { type: Object, required: true },
    quantity: { type: Number, required: true }
  },
  methods: {
    showCounter: function() {
      if (this.quantity != null) {
        return this.counter = this.quantity
      }
      return this.counter
    },
    addAddOn: function(add_on_id, item, event) {
      if (event.target.checked) {
        this.$emit('add-add-on', add_on_id, item)
      } else {
        this.$emit('remove-add-on', add_on_id, item)
      }
    },
    addItem: function(item, event) {
      const self = this
      self.counter++
      const outOfStock = response => {
        self.counter--
        swal({
          type: response.status,
          title: "Error",
          text: response.message,
          confirmButtonText: "Ok",
          confirmButtonColor: "#582D11",
          confirmButtonClass: "btn btn-brown text-uppercase",
          buttonsStyling: false
        });
      };

      const checkInventory = (id, quantity) => {
        return new Promise((resolve, reject) => {
          Rails.ajax({
            url: `/inventories?menu_id=${id}&quantity=${quantity}`,
            type: "GET",
            success: resolve,
            error: reject
          });
        });
      };

      checkInventory(item.id, self.counter).then(function(response) {
        self.$emit('add-item', item, self.counter)
      }, outOfStock);
    },
    removeItem: function(item, event) {
      this.counter--
      if (this.counter < 0) { this.counter = 0 }
      this.$emit('remove-item', item, this.counter)
    },
    imageUrl: function(item) {
      const asset = item.attributes.asset;
      if (asset === null) {
        return NoImage;
      }
      if (asset.hasOwnProperty("image")) {
        return asset.image.card.url;
      }
    },
    dietClass: function(diet) {
      const diet_name = diet.name;
      const formatted = diet_name.replace(/\s+/g, "-").toLowerCase();
      return `fa fa-star diet-icons ${formatted}`;
    },
  }
}
</script>
