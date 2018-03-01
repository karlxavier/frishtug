class Scanovator
  include Virtus.model
  include ActiveModel::Naming

  class DataAttribute < Virtus::Attribute
    def coerce values
      values.blank? ? nil : map_data(values)
    end

    private

    def map_data entries
      entries.map { |h| Scanovator::Data.new(h) }
    end
  end

  class Data
    include Virtus.model
    attribute :order_id, String
    attribute :actually_delivered, String
    attribute :eta, String
    attribute :route_started, String
    attribute :payment_details, String
    attribute :picked, String
    attribute :driver_name, String
  end

  attribute :state, String
  attribute :data, Scanovator::DataAttribute, default: []
end
