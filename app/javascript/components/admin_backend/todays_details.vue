<template>
  <div>
    <table class="table table-sm">
      <thead>
        <tr>
          <th>QTY</th>
          <th>ITEM</th>
          <th>PRICE</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in order.items" :key="item.id">
          <td>{{ item.quantity }}</td>
          <td>{{ item.name }}</td>
          <td>{{ item.price | to_currency }}</td>
        </tr>
        <tr v-for="item in add_ons" :key="`add_ons_${item.uniq_id}`">
          <td>{{ item.quantity }}</td>
          <td>{{ item.name }}</td>
          <td>{{ item.price | to_currency }}</td>
        </tr>
        <tr>
          <td colspan="2">
            <span class="float-right">
              Sub-total
            </span>
          </td>
          <td>
            {{ order.sub_total | to_currency }}
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <span class="float-right">
              Tax
            </span>
          </td>
          <td>
            {{ order.tax | to_currency }}
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <span class="float-right">
              Shipping
            </span>
          </td>
          <td>
            {{ order.shipping_fee || 0 | to_currency }}
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <span class="float-right">
              Total
            </span>
          </td>
          <td>
            {{ order.total | to_currency }}
          </td>
        </tr>
      </tbody>
    </table>
    <a href="javascript:void(0)" class="chocolate-font-color" @click="$emit('on-hide-details')">
      Hide Order Details <i class="fa fa-angle-up"></i>
    </a>
  </div>
</template>

<script>
  import toCurrency from "../../packs/lib/to_currency";
  export default {
    props: ['order'],
    filters: {
      to_currency: toCurrency,
    },
    computed: {
      add_ons() {
        const self = this
        const list = []
        self.order.items.forEach(i => {
          if (i.add_ons.length > 0) {
            list.push(...i.add_ons)
            list.forEach(l => l.uniq_id =`_${Math.random().toString(36).substr(2, 9)}`)
          }
        })
        return list
      }
    }
  }
</script>
