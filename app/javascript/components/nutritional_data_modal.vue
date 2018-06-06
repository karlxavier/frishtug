<template>
  <div class="modal fade" id="menuNutriFacts" tabindex="-1" role="dialog" aria-labelledby="modalTitle" aria-hidden="true">
      <div class="modal-dialog modal-md modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modalTitle">
              {{ item_name }}
            </h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <div class="row">
              <div class="col-md-12" v-if="nutri !== null && typeof nutri === 'object'">
                  <section class="performance-facts">
                    <header class="performance-facts__header">
                      <h2 class="performance-facts__title">Nutrition Facts</h2>
                      <p>Serving Size {{ nutri.data.serving_size }}
                      <p>Serving Per Container {{ nutri.data.servings_per_container }}</p>
                    </header>
                    <table class="performance-facts__table">
                      <thead>
                        <tr>
                          <th colspan="3" class="small-info">
                            Amount Per Serving
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <th colspan="2">
                            <b>Calories</b>
                            {{ nutri.data.calories }}
                          </th>
                          <td>
                            Calories from Fat
                            {{ nutri.data.calories_from_fat }}
                          </td>
                        </tr>
                        <tr class="thick-row">
                          <td colspan="3" class="small-info">
                            <b>% Daily Value*</b>
                          </td>
                        </tr>
                        <tr>
                          <th colspan="2">
                            <b>Total Fat</b>
                            {{ nutri.data.daily_values[0].value }}
                          </th>
                          <td>
                            <b>{{ nutri.data.daily_values[0].percent_daily_value }}</b>
                          </td>
                        </tr>
                        <tr>
                          <td class="blank-cell">
                          </td>
                          <th>
                            Saturated Fat
                            {{ nutri.data.daily_values[1].value }}
                          </th>
                          <td>
                            <b>{{ nutri.data.daily_values[1].percent_daily_value }}</b>
                          </td>
                        </tr>
                        <tr>
                          <td class="blank-cell">
                          </td>
                          <th>
                            Trans Fat
                            {{ nutri.data.daily_values[2].value }}
                          </th>
                          <td>
                            <b>{{ nutri.data.daily_values[2].percent_daily_value }}</b>
                          </td>
                        </tr>
                        <tr>
                          <th colspan="2">
                            <b>Cholesterol</b>
                            {{ nutri.data.daily_values[3].value }}
                          </th>
                          <td>
                            <b>{{ nutri.data.daily_values[3].percent_daily_value }}</b>
                          </td>
                        </tr>
                        <tr>
                          <th colspan="2">
                            <b>Sodium</b>
                            {{ nutri.data.daily_values[4].value }}
                          </th>
                          <td>
                            <b>{{ nutri.data.daily_values[4].percent_daily_value }}</b>
                          </td>
                        </tr>
                        <tr>
                          <th colspan="2">
                            <b>Total Carbohydrate</b>
                            {{ nutri.data.daily_values[5].value }}
                          </th>
                          <td>
                            <b>{{ nutri.data.daily_values[5].percent_daily_value }}</b>
                          </td>
                        </tr>
                        <tr>
                          <td class="blank-cell">
                          </td>
                          <th>
                            Dietary Fiber
                            {{ nutri.data.daily_values[6].value }}
                          </th>
                          <td>
                            <b>{{ nutri.data.daily_values[6].percent_daily_value }}</b>
                          </td>
                        </tr>
                        <tr>
                          <td class="blank-cell">
                          </td>
                          <th>
                            Sugars
                            {{ nutri.data.daily_values[7].value }}
                          </th>
                          <td>
                            <b>{{ nutri.data.daily_values[7].percent_daily_value }}</b>
                          </td>
                        </tr>
                        <tr class="thick-end">
                          <th colspan="2">
                            <b>Protein</b>
                            {{ nutri.data.daily_values[8].value }}
                          </th>
                          <td>
                            <b>{{ nutri.data.daily_values[8].percent_daily_value }}</b>
                          </td>
                        </tr>
                      </tbody>
                    </table>

                    <table class="performance-facts__table--grid">
                      <tbody v-for="vitamin in nutri.data.vitamins">
                        <tr>
                          <td colspan="2">
                            {{ vitamin.name }}
                            {{ vitamin.percent_daily_value }}
                          </td>
                        </tr>
                      </tbody>
                    </table>

                    <p class="small-info thick-row">* {{ nutri.data.description }}</p>

                    <p class="small-info">
                      Calories per gram:
                    </p>
                    <p class="small-info text-center">
                      Fat {{ nutri.data.daily_values[0].value }}
                      &bull;
                      Carbohydrate {{ nutri.data.daily_values[5].value }}
                      &bull;
                      Protein {{ nutri.data.daily_values[8].value }}
                    </p>
                  </section>
              </div>

              <div class="col-md-12">
                {{ item_description }}
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
  </div>
</template>

<script>
export default {
  props: {
    nutri: { type: Object, required: false },
    item: { type: Object, required: true }
  },
  computed: {
    item_name: function() {
      if (this.item.hasOwnProperty('attributes')) {
        return this.item.attributes.name
      } else {
        return ''
      }
    },
    item_description: function() {
      if (this.item.hasOwnProperty('attributes')) {
        return this.item.attributes.description
      } else {
        return ''
      }
    }
  }
}
</script>
