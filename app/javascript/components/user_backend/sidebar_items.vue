<template>
  <div>
    <div class="row order-list-items px-3">
      <div class="col-7 px-0 text-left text-truncate">
        <strong>{{ name }}</strong>
      </div>
      <div class="col-3 px-0 text-center">
        <a href="javascript:void(0)"
          class="remove-meal mx-1 chocolate-font-color"
          @click="$emit('remove-item', item, item.quantity - 1)">
          <i class="fa fa-minus-square-o"></i>
        </a>
        <span class="quantity">
          {{ quantity }}
        </span>
        <a href="javascript:void(0)"
          class="add-meal mx-1 chocolate-font-color"
          @click="$emit('add-item', item, item.quantity + 1)">
          <i class="fa fa-plus-square-o"></i>
        </a>
      </div>
      <div class="col-2 px-0 text-right" v-if="taxable_item">
        {{ total_price | to_currency }}
      </div>
      <div class="col-2 px-0 text-right" v-else>
        {{ total_price | to_currency }}
      </div>
    </div>
    <div class="row order-list-items px-3" v-for="add_on in item.add_ons" v-bind:key="`item_add_ons_${add_on}_${item.id}`">
      <div class="col-7 px-0 text-left text-truncate">
        <strong>{{ addOnName(item, add_on) }}</strong>
      </div>
      <div class="col-3 px-0 text-center">
        <span class="meal-count">{{ item.quantity }}</span>
      </div>
      <div class="col-2 px-0 text-right">
        {{ addOnPrice(item, add_on) | to_currency }}
      </div>
    </div>
  </div>
</template>

<script>
import toCurrency from "../../packs/lib/to_currency";
import Money from "../../packs/lib/money";
export default {
  filters: {
    to_currency: toCurrency
  },
  props: ["item", "unreduce_items"],
  computed: {
    name: function() {
      const self = this;
      const found = self.unreduce_items.filter(i => i.id === String(self.item.menu_id));
      if (found.length > 0) {
        return found[0].attributes.name;
      } else {
        return "Not Found Item";
      }
    },
    quantity: function() {
      return this.item.quantity
    },
    total_price: function() {
      const self = this;
      const found = self.unreduce_items.filter(i => i.id === self.item.menu_id);
      if (found.length > 0) {
        const price = Money.$cents(parseFloat(found[0].attributes.price))
        let total = Money.$dollar(Math.round(price * self.item.quantity));
        return total;
      } else {
        return 0;
      }
    },
    taxable_item: function() {
      const self = this;
      const found = self.unreduce_items.filter(i => i.id === self.item.menu_id);
      if (found.length > 0) {
        return found[0].attributes.tax;
      }
    }
  },
  methods: {
    addOnName: function(item, add_on_id) {
      const self = this;
      const found = self.unreduce_items.filter(i => i.id === item.menu_id);
      if (found.length > 0) {
        const add_on = found[0].meta.add_ons.filter(
          add_on => add_on.id === add_on_id
        );
        return add_on[0].name;
      }
    },
    addOnPrice: function(item, add_on_id) {
      const self = this;
      const found = self.unreduce_items.filter(i => i.id === item.menu_id);
      if (found.length > 0) {
        const add_on = found[0].meta.add_ons.filter(a => {
          return a.id === add_on_id;
        });
        return add_on[0].price;
      }
    },
  }
}
</script>

