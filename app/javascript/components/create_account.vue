<template>
  <div class="row justify-content-center align-items-start sign-up-step__container">
    <div class="col-12 col-md-4 sign-up-step__body">
      <h3 class="text-uppercase text-center">Sign Up: Create Account</h3>
      <div class="row justify-content-center">
        <div class="col-10">
          <div class="form-group row">
            <div class="col">
              <input type="text"
                class="form-control"
                v-bind:class="{ 'is-invalid': $v.registration_form.first_name.$error}"
                name="first_name"
                placeholder="First Name*"
                v-model.trim="registration_form.first_name"
                @input="$v.registration_form.first_name.$touch">
              <div class="invalid-feedback">
                First name is required and should not contain any numbers or special characters
              </div>
            </div>
            <div class="col">
               <input type="text"
                class="form-control"
                v-bind:class="{ 'is-invalid': $v.registration_form.last_name.$error}"
                name="last_name"
                placeholder="Last Name*"
                v-model.trim="registration_form.last_name"
                @input="$v.registration_form.last_name.$touch">
              <div class="invalid-feedback">
                Last name is required and should not contain any numbers or special characters
              </div>
            </div>
          </div>
          <div class="form-group">
            <input type="email"
                class="form-control"
                v-bind:class="{'is-invalid': $v.registration_form.email.$error}"
                name="email"
                placeholder="Email*"
                v-model.lazy.trim="registration_form.email"
                @input="$v.registration_form.email.$touch">
            <div class="invalid-feedback email--error"  v-show="$v.registration_form.email.email !== true">
              Invalid email format.
            </div>
            <div class="invalid-feedback email--error" v-show="$v.registration_form.email.required !== true">
              Email is required
            </div>
            <div class="invalid-feedback" v-show="$v.registration_form.email.isUnique === false">
              Email already exists!. <a href="users/password/new">Forgot your password?</a>
            </div>
          </div>
          <div class="form-group">
            <input type="password"
                class="form-control"
                v-bind:class="{ 'is-invalid': $v.registration_form.password.$error}"
                name="password"
                placeholder="Password*"
                v-model.trim="registration_form.password"
                @input="$v.registration_form.password.$touch">
            <div class="invalid-feedback">
              Password is required, Minimum of 6 characters
            </div>
          </div>
          <div class="text-center">
            <a href="javascript:void(0)"
              class="btn btn-brown text-uppercase width-185"
              @click="verifyEmail">Next Step</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { required, minLength, email } from 'vuelidate/lib/validators'
import swal from 'sweetalert2'
export default {
  data: () => {
    return {
      email_error: 'Email is required',
      is_valid: '',
    }
  },
  props: {
    registration_form: { type: Object, required: true }
  },
  validations: {
    registration_form: {
      first_name: {
        required
      },
      last_name: {
        required
      },
      email: {
        email,
        required,
        isUnique(value) {
          return new Promise((resolve) => {
            Rails.ajax({
              url: `/api/v1/verify_users?email=${value}`,
              type: "GET",
              success: function (response) {
                resolve(response.status !== 'error')
              }
            })
          })
        }
      },
      password: {
        required,
        minLength: minLength(6)
      }
    }
  },
  methods: {
    validate: function(event) {
      if (event.target.value.trim() === '') {
        event.target.classList.add('is-invalid')
        return false
      } else {
        event.target.classList.remove('is-invalid')
        return true
      }
    },
    continue: function(element) {
      const self = this
      self.$v.registration_form.$touch()
      const isValid = !self.$v.registration_form.$invalid
      if (isValid) {
        return self.$emit('next-tab')
      } else {
        swal({
          type: "error",
          title: "Error",
          text: "Please fill all the required fields",
          confirmButtonText: "Ok",
          confirmButtonColor: "#582D11",
          confirmButtonClass: "btn btn-brown text-uppercase",
          buttonsStyling: false
        })
        return
      }
    },
    verifyEmail: function() {
      const self = this

      if (self.registration_form.email.trim() === '') {
        swal({
          type: "error",
          title: "Error",
          text: "Please provide an email.",
          confirmButtonText: "Ok",
          confirmButtonColor: "#582D11",
          confirmButtonClass: "btn btn-brown text-uppercase",
          buttonsStyling: false
        })
        return
      }

      const user_data = {
        inactive_user: {
          email: self.registration_form.email,
          first_name: self.registration_form.first_name,
          last_name: self.registration_form.last_name
        }
      }

      $.ajax({
        url: '/api/v1/inactive_users',
        type: 'POST',
        data: user_data,
        dataType: 'json'
      })

      self.continue()
    }
  }
}
</script>

