<template>
  <div class="row justify-content-center align-items-center" style="margin-top: 1.6rem;">
    <div class="col-12 col-md-4" style="margin-bottom: 1rem;">
      <h3 class="text-uppercase text-center">Delivery Information</h3>
      <div class="row justify-content-center">
        <div class="col-10">
          <div v-for="(address, index) in registration_form.addresses">
            <div class="form-group row" v-if="index === 0">
              <div class="col-3">
                <strong>I am:</strong>
              </div>
              <div class="col">
                <label v-for="location_at in location_ats" class="delivery-info-step__control_label mr-3" v-bind:key="location_at">
                  <input type="radio" :name="location_at" :id="location_at" style="margin-right: 5px" v-model="registration_form.addresses[0].location_at" :value="location_at" v-on:click="changeAddress(location_at)">
                  {{ location_at }}
                </label>
              </div>
            </div>
            <div v-else>
              <input type="hidden" v-model.lazy="address.location_at" name="location_at">
            </div>
            <div class="form-group">
              <input type="text"
                v-model="address.line1"
                placeholder="Address Line 1"
                class="form-control"
                v-bind:class="{ 'is-invalid': $v.address.line1.$error}"
                @input="$v.address.line1.$touch">
              <div class="invalid-feedback">
                Line1 is required
              </div>
            </div>
            <div class="form-group">
              <input type="text" v-model="address.line2" placeholder="Address Line 2" class="form-control">
            </div>
            <div class="form-group">
              <input type="text" v-model="address.front_door" placeholder="Front Door Code (if applicable)" class="form-control">
            </div>
            <div class="form-group row">
              <div class="col">
                <input type="text"
                  v-model="address.city"
                  placeholder="City"
                  class="form-control"
                  v-bind:class="{ 'is-invalid': $v.address.city.$error}"
                  @input="$v.address.city.$touch">
                <div class="invalid-feedback">
                  City is required
                </div>
              </div>
              <div class="col">
                <input type="text"
                  v-model="address.state"
                  placeholder="State"
                  class="form-control"
                  v-bind:class="{ 'is-invalid': $v.address.state.$error}"
                  @input="$v.address.state.$touch">
                <div class="invalid-feedback">
                  State is required
                </div>
              </div>
            </div>
            <div class="form-group row">
              <div class="col">
                <input type="text"
                  v-model="address.zip_code"
                  placeholder="Zipcode"
                  class="form-control"
                  v-bind:class="{ 'is-invalid': $v.address.zip_code.$error}"
                  v-mask="'#####'"
                  @input="$v.address.zip_code.$touch">
                <div class="invalid-feedback">
                  Zip code is required and must be a US valid zip.
                </div>
              </div>
              <div class="col" v-if="index === 0">
                <input type="text"
                  v-model="registration_form.phone_number"
                  placeholder="Phone Number"
                  class="form-control"
                  v-bind:class="{ 'is-invalid': $v.address.phone_number.$error}"
                  v-mask="'###-###-####'"
                  @input="$v.address.phone_number.$touch">
                <div class="invalid-feedback">
                  Phone Number is required
                </div>
              </div>
            </div>
          </div>
          <div class="form-group" v-show="plan.for_type === 'group'">
            <input type="text" v-model="registration_form.group_code" placeholder="Group Code" class="form-control">
          </div>
          <a href="javascript:void(0)"
            class="chocolate-font-color"
            @click="addAddress"
            v-if="registration_form.addresses[0].location_at === 'multiple_workplaces'">
            + Add Next Address
          </a>
          <div class="text-center">
            <a href="javascript:void(0)"
              class="btn btn-brown width-185 text-uppercase mt-3"
              @click="validate">Next</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>


<script>
import { required } from 'vuelidate/lib/validators'
export default {
  props: {
    registration_form: { type: Object, required: true },
    plan: { type: Object, required: true }
  },
  data: () => {
    return {
      location_ats: ["at_home", "at_work", "multiple_workplaces"],
      invalids: 0
    }
  },
  validations: {
    address: {
      city: {
        required
      },
      state: {
        required
      },
      line1: {
        required
      },
      zip_code: {
        required
      },
      phone_number: {
        required
      }
    }
  },
  methods: {
    changeAddress: function(location_at) {
      if (location_at !== 'multiple_workplaces') {
        const newAddress = []
        newAddress.push(this.registration_form.addresses[0])
        this.registration_form.addresses = newAddress
      }
    },
    validate: function() {
      const self = this
      const group_code = self.registration_form.group_code
      self.$v.address.$touch()
      const isInValid = self.$v.registration_form.$invalid
      if (isInValid) { return false }
      if (group_code === null) {
        return self.$emit('next-tab')
      }

      const responseHandler = response => {
        if (response.is_valid !== true) {
          swal({
            type: "error",
            title: "Group Code Invalid",
            text: "Group code is invalid!",
            confirmButtonText: "Continue",
            confirmButtonColor: "#582D11",
            confirmButtonClass: "btn btn-brown text-uppercase",
            buttonsStyling: false
          });
        } else {
          return self.$emit('next-tab')
        }
      };

      Rails.ajax({
        url: `/api/v1/check_codes?group_code=${group_code}`,
        type: "GET",
        success: function(response) {
          responseHandler(response);
        }
      });
    },
    addAddress: function() {
      const self = this
      self.registration_form.addresses.push({
        line1: null,
        line2: null,
        front_door: null,
        city: null,
        state: null,
        zip_code: null,
        location_at: self.registration_form.addresses[0].location_at
      })
    }
  }
}
</script>
