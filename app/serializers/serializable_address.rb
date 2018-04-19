class SerializableAddress < JSONAPI::Serializable::Resource
  type 'addresses'
  attributes :id,
             :line1,
             :line2,
             :front_door,
             :state,
             :city,
             :zip_code,
             :location_at,
             :status
end