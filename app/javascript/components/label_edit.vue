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
const ADDRESS_COMPONENTS = {
		street_number: 'short_name',
		route: 'long_name',
		locality: 'long_name',
		administrative_area_level_1: 'short_name',
		administrative_area_level_2: 'county',
		country: 'long_name',
		postal_code: 'short_name',
		sublocality_level_1: 'long_name'
};
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
    getAddressResult: function(place, placeResultData, id) {
      const self = this
			const currentAddress = self.address
			const data = self.formatResult(placeResultData)

      if (data.street_number != null) {
        currentAddress.line1 = `${data.street_number} ${data.route}`
      } else {
        currentAddress.line1 = data.route
			}
			
			if (data.hasOwnProperty('locality')) {
				currentAddress.city = data.locality
			} else {
				currentAddress.city = data.sublocality_level_1
			}
      
      currentAddress.zip_code = data.postal_code
			currentAddress.state = data.administrative_area_level_1
			self.label = currentAddress.line1
      self.edit = false
		},
		formatResult: function(place) {
				let returnData = {};
				for (let i = 0; i < place.address_components.length; i++) {
						let addressType = place.address_components[i].types[0];
						if (ADDRESS_COMPONENTS[addressType]) {
								let val = place.address_components[i][ADDRESS_COMPONENTS[addressType]];
								returnData[addressType] = val;
						}
				}
				returnData['latitude'] = place.geometry.location.lat();
				returnData['longitude'] = place.geometry.location.lng();
				return returnData
		},
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
