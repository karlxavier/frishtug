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
          @click="addItem(item)">
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
    <div class="row order-list-items px-3" v-for="add_on in item.add_ons" v-bind:key="`item_add_ons_${add_on}__${item.id}`">
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
        return "Item not found";
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
    addItem: function(item) {
      const self = this
      const outOfStock = response => {
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

      checkInventory(item.menu_id, item.quantity + 1).then(function(response) {
        self.$emit('add-item', item, item.quantity + 1)
      }, outOfStock);
    },
    addOnName: function(item, add_on_id) {
      const self = this;
      const found = self.unreduce_items.filter(i => i.id === item.menu_id);
      console.log(found)
      if (found.length > 0) {
        const add_on = found[0].meta.add_ons.filter(
          add_on => add_on.id == add_on_id
        );
        return add_on[0].name;
      } else {
        return "Item not found"
      }
    },
    addOnPrice: function(item, add_on_id) {
      const self = this;
      const found = self.unreduce_items.filter(i => i.id === item.menu_id);
      if (found.length > 0) {
        const add_on = found[0].meta.add_ons.filter(a => {
          return a.id == add_on_id;
        });
        const price = Money.$cents(add_on[0].price);
        const total = price * item.quantity;
        return Money.$dollar(total);
      }
    },
  }
}
</script>

