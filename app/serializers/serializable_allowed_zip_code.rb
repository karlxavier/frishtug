class SerializableAllowedZipCode < JSONAPI::Serializable::Resource
  type 'allowed_zip_codes'
  attribute :zip
end