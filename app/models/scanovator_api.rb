require 'uri'
class ScanovatorApi
  include ActiveModel::Validations
  include HTTParty

  base_uri 'barcoder-cyf.herokuapp.com/public'
  debug_output $stdout unless Rails.env.production?

  STORE_ID = Store.first._id.freeze
  STORE_CODE = Store.first._code.freeze
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
      response = get("/new_order?#{new_order_query(order)}")
      process_response response.body
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
        store_id: nil,
        store_code: STORE_CODE,
        fname: order.user.first_name,
        lname: order.user.last_name,
        street_address: street_address(order),
        city: order.user.addresses.first.city,
        state: order.user.addresses.first.state,
        zip: order.user.addresses.first.zip_code,
        numofboxes: 1,
        phone: order.user.contact_number.phone_number,
        cell1: nil,
        cell2: nil,
        eadd: order.user.email,
        order_id: order.id,
        notes: nil
      })
    end

    def street_address order
      address = order.user.addresses.first
      [address.line1, address.line2].reject(&:blank?).join(', ').strip
    end
  end
end
