<template>
  <div class="row justify-content-center align-items-center" style="margin-top: 1.6rem;">
    <div class="col-md-6 col-md-offset-4" style="margin-bottom: 1rem;">
      <h3 class="text-uppercase text-center">Delivery Information</h3>
      <div class="row justify-content-center">
        <div class="col-10">
          <div v-for="(address, index) in registration_form.addresses" v-bind:key="`address_${index}`">
            <div class="form-group row" v-if="index === 0">
              <div class="col-3">
                <strong>I am:</strong>
              </div>
              <div class="col">
                <label v-for="location_at in location_ats" class="delivery-info-step__control_label mr-3" v-bind:key="location_at">
                  <input type="radio" :name="location_at" :id="location_at" style="margin-right: 5px" v-model="registration_form.addresses[0].location_at" :value="location_at" v-on:click="changeAddress(location_at)">
                  {{ location_at | format }}
                </label>
              </div>
            </div>
            <div v-else>
              <input type="hidden" v-model.lazy="address.location_at" name="location_at">
            </div>
            <div class="form-group">
              <vue-google-autocomplete
                  ref="address_autocomplete"
                  :id="`map_${index}`"
                  classname="form-control"
                  placeholder="Please type your address"
                  v-on:placechanged="getAddressResult"
                  country="us"
                  v-show="autocomplete_shown[index]"
                  @blur="hideAutoComplete(index)"
              >
              </vue-google-autocomplete>
              <input type="text"
                ref="address_line1"
                v-model.trim="address.line1"
                placeholder="Address Line 1"
                class="form-control"
                v-bind:class="{ 'is-invalid': $v.registration_form.addresses.$each[index].line1.$error}"
                @input="$v.registration_form.addresses.$each[index].line1.$touch"
                v-show="!autocomplete_shown[index]"
                @focus="showAutoComplete(index)">
              <div class="invalid-feedback">
                Line1 is required
              </div>
            </div>
            <div class="form-group">
              <input type="text" v-model.trim="address.line2" placeholder="Address Line 2" class="form-control">
            </div>
            <div class="form-group">
              <input type="text" v-model="address.front_door" placeholder="Front Door Code (if applicable)" class="form-control">
            </div>
            <div class="form-group row">
              <div class="col">
                <input type="text"
                  v-model.trim="address.city"
                  placeholder="City"
                  class="form-control"
                  v-bind:class="{ 'is-invalid': $v.registration_form.addresses.$each[index].city.$error}"
                  @input="$v.registration_form.addresses.$each[index].city.$touch">
                <div class="invalid-feedback">
                  City is required
                </div>
              </div>
              <div class="col">
                <input type="text"
                  v-model="address.state"
                  placeholder="State"
                  class="form-control"
                  v-bind:class="{ 'is-invalid': $v.registration_form.addresses.$each[index].state.$error}"
                  @input="$v.registration_form.addresses.$each[index].state.$touch"
                  v-mask="'AA'"
                  style="text-transform:uppercase"
                  >
                <div class="invalid-feedback">
                  State is required
                </div>
              </div>
            </div>
            <div class="form-group row">
              <div class="col">
                <input type="text"
                  v-model.trim="address.zip_code"
                  placeholder="Zipcode"
                  class="form-control"
                  v-bind:class="{ 'is-invalid': $v.registration_form.addresses.$each[index].zip_code.$error}"
                  v-mask="'#####'"
                  @input="$v.registration_form.addresses.$each[index].zip_code.$touch">
                <div class="invalid-feedback">
                  Zip code is required and must be a US valid zip.
                </div>
              </div>
              <div class="col" v-if="index === 0">
                <input type="text"
                  v-model.trim="registration_form.phone_number"
                  placeholder="Phone Number"
                  class="form-control"
                  v-bind:class="{ 'is-invalid': $v.registration_form.phone_number.$error}"
                  v-mask="'###-###-####'"
                  @input="$v.registration_form.phone_number.$touch">
                <div class="invalid-feedback">
                  Phone Number is required
                </div>
              </div>
            </div>
          </div>
          <div class="form-group" v-show="plan.for_type === 'group'">
            <input type="text"
              v-model.trim="registration_form.group_code"
              placeholder="Group Code"
              class="form-control"
              v-on:blur="getAddress">
            <small id="groupCodeHelpBlock" class="form-text text-muted">
              If your the First one setting up your Group we will supply you with a group code at check out.
            </small>
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
import { required } from "vuelidate/lib/validators";
import VueGoogleAutocomplete from 'vue-google-autocomplete';
export default {
  components: {
    VueGoogleAutocomplete
  },
  props: {
    registration_form: { type: Object, required: true },
    plan: { type: Object, required: true }
  },
  data: () => {
    return {
      location_ats: ["at_home", "at_work", "multiple_workplaces"],
      invalids: 0,
      allowed_zip_codes: [],
      autocomplete_shown: [true]
    };
  },
  filters: {
    format: function(text) {
      const str = text.split("_");
      for (var i = 0; i < str.length; i++) {
        str[i] = str[i].charAt(0).toUpperCase() + str[i].slice(1);
      }
      return str.join(" ");
    }
  },
  validations: {
    registration_form: {
      phone_number: { required },
      addresses: {
        required,
        $each: {
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
          }
        }
      }
    }
  },
  mounted() {
    const self = this;
    const fetchAllowedZip = () => {
      return new Promise(resolve => {
        Rails.ajax({
          url: "/api/v1/allowed_zip_codes",
          type: "GET",
          success: resolve
        });
      });
    };

    fetchAllowedZip().then(function(response) {
      self.allowed_zip_codes = Array.from(response.data).map(
        data => data.attributes.zip
      );
    });
    self.$refs.address_autocomplete[0].focus()
  },
  methods: {
    hideAutoComplete: function(index) {
      const self = this
      self.autocomplete_shown[index] = false
    },
    showAutoComplete: function(index) {
      const self = this
      self.autocomplete_shown[index] = true
      self.$refs.address_autocomplete[index].focus()
    },
    getAddressResult: function(data, placeResultData, id) {
      const self = this
      const index = id.split('_')[1]
      const currentAddress = self.registration_form.addresses[index]

      if (data.street_number != null) {
        currentAddress.line1 = `${data.street_number} ${data.route}`
      } else {
        currentAddress.line1 = data.route
      }
      currentAddress.city = data.locality
      currentAddress.zip_code = data.postal_code
      currentAddress.state = data.administrative_area_level_1
      self.autocomplete_shown[index] = false
    },
    getAddress: function() {
      const self = this;
      const group_code = self.registration_form.group_code;
      if (group_code.trim() !== '') {
        Rails.ajax({
          url: `/api/v1/get_address?group_code=${group_code}`,
          type: 'GET',
          success: function(response) {
            const address = response.address
            self.registration_form.addresses = [{
              line1: address.line1,
              line2: address.line2,
              front_door: address.front_door,
              city: address.city,
              state: address.state,
              zip_code: address.zip_code,
              location_at: address.location_at
            }]
          }
        });
      }
    },
    // checkCase: function(event) {
    //   const value = event.target.value
    //   console.log(value)
    //   if (!isNaN(value)) { event.target.value = '' }
    //   if (value !== value.toUpperCase()) {
    //     event.target.value = ''
    //   }
    // },
    changeAddress: function(location_at) {
      if (location_at !== "multiple_workplaces") {
        const newAddress = [];
        newAddress.push(this.registration_form.addresses[0]);
        this.registration_form.addresses = newAddress;
      }
    },
    isZipCodeAllowed: function() {
      const self = this;
      const isValid = self.registration_form.addresses.every(address => {
        return self.allowed_zip_codes.includes(address.zip_code);
      });

      if (!isValid) {
        swal({
          type: "error",
          title: "Error",
          text: "We don't deliver to your zip code",
          confirmButtonText: "Continue",
          confirmButtonColor: "#582D11",
          confirmButtonClass: "btn btn-brown text-uppercase",
          buttonsStyling: false
        }).then(response => {
          self.validateAddress();
        });
      } else {
        self.validateAddress();
      }
    },
    checkGroupCode: function() {
      const self = this;
      const group_code = self.registration_form.group_code;

      if (group_code === null) {
        return self.$emit("next-tab");
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
          return self.$emit("next-tab");
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
    validateAddress: function() {
      const self = this;
      let processedAddress = 0
      const invalid = []
      const validate_address = address => {
        return new Promise((resolve, reject) => {
          Rails.ajax({
            url: `/api/v1/address?location=${address}`,
            type: "GET",
            success: function(response) {
              resolve(response.valid);
            }
          });
        });
      };

      self.registration_form.addresses.forEach( (address, index, array) => {
        processedAddress++
        const full_address = [
          address.line1,
          address.line2,
          address.city,
          address.state,
          address.zip_code
        ].filter(e => !!e).join(", ");

        validate_address(encodeURIComponent(full_address).replace(/%20/g, '+')).then(response => {
          if (!response) {
            invalid.push(full_address);
          }

          if (processedAddress === array.length) {
            done()
          }
        });
      });

      const done = () => {
        if (invalid.length > 0) {
          swal({
            type: "error",
            title: "Address Not Valid!",
            text: invalid.join("|"),
            confirmButtonText: "Ok",
            confirmButtonColor: "#582D11",
            confirmButtonClass: "btn btn-brown text-uppercase",
            buttonsStyling: false
          });
        } else {
          self.checkGroupCode();
        }
      }
    },
    validate: function() {
      const self = this;
      self.$v.registration_form.$touch();
      const isInValid = self.$v.registration_form.$invalid;
      if (isInValid) {
        return false;
      } else {
        self.isZipCodeAllowed();
      }
    },
    addAddress: function() {
      const self = this;
      self.registration_form.addresses.push({
        line1: null,
        line2: null,
        front_door: null,
        city: null,
        state: null,
        zip_code: null,
        location_at: self.registration_form.addresses[0].location_at
      });
      self.autocomplete_shown.push(true)
    }
  }
};
</script>

