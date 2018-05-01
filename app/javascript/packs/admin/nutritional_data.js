import Vue from "vue/dist/vue.esm";
import VueResource from "vue-resource";

Vue.use(VueResource);
Vue.http.headers.common["X-CSRF-Token"] = document
  .querySelector('meta[name="csrf-token"]')
  .getAttribute("content");

const mountVm = () => {
  const form = document.querySelector("#nutritional_data_form");

  if (!form) {
    return;
  }

  const json_data = JSON.parse(form.getAttribute('data'))
  const vm = new Vue({
    el: form,
    data: {
      nutritional_data: {
        menu_id: json_data.menu_id,
        data: {
          serving_size: "1 slice(46g)",
          servings_per_container: 1,
          calories: 240,
          calories_from_fat: 110,
          daily_values: [
            {
              name: "Total Fat",
              value: "16g",
              percent_daily_value: "22%"
            },
            {
              name: "Saturated Fat",
              value: "7g",
              percent_daily_value: "35%"
            },
            {
              name: "Trans Fat",
              value: "0",
              percent_daily_value: null
            },
            {
              name: "Cholesterol",
              value: "95mg",
              percent_daily_value: "32%"
            },
            {
              name: "Sodium",
              value: "370mg",
              percent_daily_value: "15%"
            },
            {
              name: "Total Carbohydrates",
              value: "58g",
              percent_daily_value: "19%"
            },
            {
              name: "Dietary Fiber",
              value: "3g",
              percent_daily_value: "12%"
            },
            {
              name: "Sugars",
              value: "14g",
              percent_daily_value: null
            },
            {
              name: "Protein",
              value: "42g",
              percent_daily_value: "19%"
            }
          ],
          vitamins: [
            {
              name: "Vitamin A",
              percent_daily_value: "20%"
            },
            {
              name: "Vitamin C",
              percent_daily_value: "110%"
            },
            {
              name: "Iron",
              percent_daily_value: "20%"
            },
            {
              name: "Calcium",
              percent_daily_value: "6%"
            }
          ],
          size: "46g",
          description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam imperdiet felis at odio pretium pulvinar. Maecenas ac interdum mauris, nec bibendum ipsum. Proin a vehicula orci."
        }
      }
    },
    mounted() {
      const self = this;
      if (json_data.id != null) {
        self.nutritional_data = json_data;
      }
    },
    methods: {
      remove: function(index) {
        this.nutritional_data.data.vitamins.splice(index, 1);
      },
      add: function() {
        this.nutritional_data.data.vitamins.push({
          name: null,
          percent_daily_value: null
        });
      },
      submit: function(type) {
        if (type === 'new') {
          this.$http
            .post(`/admin/nutritional_data`, {
              nutritional_data: this.nutritional_data
            })
            .then(response => {
                if (response.body.status === "success") {
                  const menu_id = this.nutritional_data.menu_id;
                  const target = document.querySelector(`#new-btn--nutritional-data--${menu_id}`);
                  target.innerHTML = "Edit Nutritional Data";
                  target.href = `
                    /admin/nutritional_data/${response.body.id}/edit.js?menu_id=${menu_id}
                  `;
                  swal({
                    type: "success",
                    title: "Successful!",
                    text: "Nutritional data successfully created",
                    confirmButtonText: "Done",
                    confirmButtonColor: "#582D11",
                    confirmButtonClass:
                      "btn btn-matterhorn text-uppercase",
                    buttonsStyling: false
                  });
                }
              }, response => {
                console.warn(response);
              });
        } else {
          this.$http
            .put(`/admin/nutritional_data/${this.nutritional_data.id}`, {
              nutritional_data: this.nutritional_data
            })
            .then(response => {
                if (response.body.status === "success") {
                  swal({
                    type: "success",
                    title: "Successful!",
                    text: "Nutritional data updated successfully",
                    confirmButtonText: "Done",
                    confirmButtonColor: "#582D11",
                    confirmButtonClass:
                      "btn btn-matterhorn text-uppercase",
                    buttonsStyling: false
                  });
                }
              }, response => {
                console.warn(response);
              });
        }
      }
    }
  });
};
mountVm();
window.mountVm = mountVm;
