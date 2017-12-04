# New Order Options
# store_id (this will be supplied to you for each store)
# store_code (this will be supplied to you for each store)
# fname (the First Name of the Customer)
# lname (the Last Name of the Customer) either a First Name or a Last Name are required
# street_address - (required)
# unit - (the unit or apartment number part of customer address - not required for script to run but really helps with delivery if available)
# city - (required)
# state (2 letters) - (Required)
# zip - (required - we need to retrieve the proper GeoCoordinates for an address without error so
# numofboxes - (Required) - the total number of boxes this order has)
# phone - (optional - the home phone number of customer - not required for script to run but important to include if available)
# cell1 - (optional - a cell phone number of customer - not required for script to run but important to include if available)
# cell2 - (optional - another cell phone number of customer - not required for script to run but important to include if available)
# order_id - (Required and has to be unique for this store - this may be any combination of letters or numbers).If they want to make a change to an existing order they can use the order id again and instead of a new record coming into our database the existing one will be overwritten
# collect - (optional - amount of money that is to be collected)
# cod - (optional - if money has to be collected COD, submit 1)
# notes - (optional any special notes the delivery driver should be aware of
# desc - (optional a description of the sale or item


class Scanovator
#   include ActiveModel::Validations
#   include HTTParty
#   base_uri 'https://barcoder-cyf.herokuapp.com/public'

#   ERROR_CODES = {
#     'SI': 'Store ID missing or incorrect',
#     'SC': 'Store Code missing or incorrect',
#     'FLN': 'need at least first or last name, none supplied',
#     'SA': 'street address missing',
#     'C': 'city missing',
#     'S': 'state missing',
#     'Z': 'zip code missing',
#     'OI': 'order number missing',
#     'OINU': 'order number not unique',
#     'NOB': 'total number of boxes missing'
#   }.freeze

#   def initialize(order)
#     @order = order
#     @store = Store.active
#   end

#   def run
#     self.class.get('/new_order', new_order_options)
#   end

#   def query_order
#     response = self.class.get('/order_query', query_options)
#     response = HashParser.new(response.parsed_response).run
#     if response.state == 'success'
#       return response.data
#     else
#       errors.add(:base, 'cant find order_id')
#       false
#     end
#   end

# private

#   attr_accessor :order

#   def address
#     order.user.addresses.first
#   end

#   def new_order_options
#     {
#       query: {
#         store_id: ,
#         store_code: ,
#         fname: order.user.first_name,
#         lname: order.user.last_name,
#         street_address: ,
#         unit: ,
#         city: address.city,
#         state: address.state,
#         zip: address.zip_code,
#         numofboxes: ,
#         phone: order.user.contact_number.phone_number,
#         cell1: ,
#         cell2: ,
#         order_id: order.code,
#         collect: ,
#         cod: ,
#         notes: ,
#         desc:
#       }
#     }
#   end

#   def query_options
#     {
#       query: {
#         store_id: 15,
#         "order_id[]": order.code 
#       }
#     }
#   end
end