require 'uri'
class ScanovatorApi
  include ActiveModel::Validations
  include HTTParty

  base_uri 'https://barcoder-cyf.herokuapp.com/public'
  debug_output $stdout unless Rails.env.production?

  STORE_ID = Store.first._id.freeze
  STORE_CODE = Store.first._code.freeze
  ALLOWED_ZIP_CODES = AllowedZipCode.pluck(:zip).freeze
  ERROR_CODES = {
    SI: 'Store ID missing or incorrect ',
    SC: 'Store Code missing or incorrect ',
    FLN: 'need at least first or last name, none supplied',
    SA: 'street address missing',
    C: 'city missing',
    S: 'state missing',
    Z: 'zip code missing',
    OI: 'order number missing',
    OINU: 'order number not unique',
    NOB: 'total number of boxes missing'
  }.with_indifferent_access.freeze

  attr_accessor :response

  def initialize response
    @response = response
  end

  class << self
    def new_order order
      return unless address_allowed?(order)
      response = get("/new_order?#{new_order_query(order)}")
      OpenStruct.new(JSON.parse(response.body))
    end

    def fetch order_id
      response = get("/order_query?store_id=#{STORE_ID}&order_id[]=#{order_id}")
      Scanovator.new(parse(response))
    end

    def fetch_group order_ids
      response = get("/order_query?store_id=#{STORE_ID}&#{format_order_ids(order_ids)}")
      Scanovator.new(parse(response))
    end

    private

    def valid_address?(order)
      full_address = order.user.active_address.full_address
      geocode = Geocoder.coordinates(full_address)
      geocode.blank?
    end

    def address_allowed?(order)
      zip = order.user.active_address.zip_code
      ALLOWED_ZIP_CODES.include?(zip)
    end

    def process_response response
      sanitize_response = strip_tag response
      if sanitize_response =~ /Error Code/i
        scanovator = new(sanitize_response)
        scanovator.errors.add(:base, ERROR_CODES[sanitize_response.split(' ')[2]])
        scanovator
      else
        true
      end
    end

    def strip_tag html_string
      ActionView::Base.full_sanitizer.sanitize(html_string)
    end

    def parse response
      JSON.parse(response.body)
          .with_indifferent_access
          .slice(*Scanovator.attribute_set.map(&:name))
    end

    def format_order_ids order_ids
      order_ids.map { |id| "order_id[]=#{id}" }.join('&')
    end

    def new_order_query order
      URI.encode_www_form({
        store_id: STORE_ID,
        store_code: STORE_CODE,
        fname: order.user.first_name,
        lname: order.user.last_name,
        street_address: order.user.street_address,
        city: order.user.active_address.city,
        state: order.user.active_address.state,
        zip: order.user.active_address.zip_code,
        numofboxes: 1,
        phone: order.user.contact_number.phone_number,
        cell1: nil,
        cell2: nil,
        eadd: order.user.email,
        order_id: order.id,
        notes: nil,
        DeliveryDate: order.placed_on,
        seq: order.series_number
      })
    end
  end
end
