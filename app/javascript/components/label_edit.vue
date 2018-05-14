<template>
  <div class="vlabeledit">
		<div class="form-control"
      @click="onLabelClick"
      v-if="!edit" style="font-style: italic;">{{vlabel}}</div>
    <vue-google-autocomplete
        ref="labeledit"
        id="map_address"
        classname="form-control"
        :placeholder="vplaceholder"
        v-on:placechanged="getAddressResult"
        country="us"
        v-if="edit"
    ></vue-google-autocomplete>
	</div>
</template>

<script>
import VueGoogleAutocomplete from 'vue-google-autocomplete';
export default {
	name: 'LabelEdit',
  components: {
    VueGoogleAutocomplete
  },
	data: function(){
		return {
			edit: false,
			label: '',
			empty: 'Address Line 1',
		}
	},
	props: [
    'text',
    'placeholder',
    'address'
  ],
	methods: {
		initText: function(){
			if(this.text==''||this.text==undefined){
				this.label = this.vlabel
			}else{
				this.label = this.text
			}
		},
		onLabelClick: function(){
			this.edit = true;
			this.label = this.text;
		},
    getAddressResult: function(data, placeResultData, id) {
      const self = this
      const currentAddress = self.address

      if (data.street_number != null) {
        currentAddress.line1 = `${data.street_number} ${data.route}`
      } else {
        currentAddress.line1 = data.route
      }
      currentAddress.city = data.locality
      currentAddress.zip_code = data.postal_code
			currentAddress.state = data.administrative_area_level_1
			self.label = currentAddress.line1
      self.edit = false
    }
	},
	computed: {
		vplaceholder: function(){
			if(this.placeholder==undefined || this.placeholder==''){
			 	return this.empty
			}else{
				return this.placeholder
			}
		},
		vlabel: function(){
			if(this.text==undefined||this.text==''){
				return this.vplaceholder
			}else{
				return this.label
			}
		}
	},
	mounted: function(){
		this.initText();
	},
	updated: function(){
		var ed = this.$refs.labeledit;
		if(ed!=null){
			ed.focus();
		}
	},
	watch: {
		text: function(value){
			if(value==''||value==undefined){
				this.label = this.vplaceholder
			}
		}
	}
}
</script>
