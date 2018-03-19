class SerializablePlan < JSONAPI::Serializable::Resource
  type 'plans'
  attributes  :name,
              :description,
              :short_description,
              :price,
              :shipping,
              :shipping_note,
              :shipping_fee,
              :for_type,
              :interval,
              :limit,
              :minimum_credit_allowed,
              :stripe_plan_id
end