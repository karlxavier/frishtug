# Admin.create(email: 'admin@frishtug.com', password: 'frishtug2017!')

# %w[ounce pound milligram gram kilogram liter cup].each do |name|
#   Unit.create(name: name)
# end

# ['Bread - Rolls', 'Salads - Smears',
#  'Vegetables', 'Side Dishes',
#  'Drinks', 'Ready Sandwiches'].each do |name|
#   MenuCategory.create(name: name)
# end

# ['Sugar Free', 'Gluten Free', 'Carb Free', 'May Contain Allergens'].each do |name|
#   DietCategory.create(name: name)
# end

# Plan.delete_all
# Plan.create([
#   {
#     name: 'Option 1',
#     description: '$20 per day, at $400 monthly',
#     price: 400,
#     interval: 'month',
#     shipping: :free,
#     note: 'Incididunt esse elit magna incididunt nulla. Sunt ipsum eu cillum nisi officia labore. Anim ullamco esse nulla aliqua minim officia elit sint nostrud occaecat velit sint.',
#       interval: 'month',
#       for_type: 'individual'
#   },
#   {
#     name: 'Option 2',
#     description: '$14.95 x 20 days = $299',
#     price: 299,
#     interval: 'month',
#     shipping: :free,
#     note: 'Voluptate ipsum ipsum cupidatat amet sint ea. Reprehenderit deserunt consectetur veniam sunt dolore.',
#       interval: 'month',
#       for_type: 'individual'
#   },
#   {
#     name: 'Option 3',
#     description: '$10 per day, at $200 monthly',
#     price: 200,
#     interval: 'month',
#     shipping: :paid,
#     shipping_fee: 40,
#     shipping_note: 'Additional $40 for Delivery',
#     note: 'Dolor occaecat commodo nostrud culpa deserunt. Aliqua nisi voluptate cillum aliquip proident commodo ea irure Lorem anim ut.',
#       interval: 'month',
#       for_type: 'group'
#   },
#   {
#     name: 'Option 4',
#     description: 'Single breakfast at $25',
#     price: 25,
#     interval: nil,
#     shipping: :paid,
#     shipping_fee: 40,
#     shipping_note: 'Delivery will be xx USD',
#     note: 'Mollit eiusmod est est commodo qui. Laboris enim laboris qui sunt quis consectetur laboris minim dolor anim irure ut esse in.',
#       for_type: 'individual'
#   }
# ])

# StripePlanner.new(Plan.first).run
# StripePlanner.new(Plan.second).run
# StripePlanner.new(Plan.third).run

# AllowedZipCode.create([
#   { zip: "10901" },
#   { zip: "10952" },
#   { zip: "10956" },
#   { zip: "10960" },
#   { zip: "10954" },
#   { zip: "10977" },
#   { zip: "10970" },
#   { zip: "10982" },
#   { zip: "10950" },
#   { zip: "10930" },
# ])

option_1 = Plan.find_by_name('Option 1')
option_2 = Plan.find_by_name('Option 2')
option_3 = Plan.find_by_name('Option 3')
option_4 = Plan.find_by_name('Option 4')

option_1.update_attributes(
  short_description: '$20/day. $400/month',
  description: '20 daily deliveries. Just choose your start date.
  This plan covers up to $20 of choices from our menu.
  Any amount above your option plan will be charged accordingly.',
)

option_2.update_attributes(
  short_description: '$14.95/day $299/month',
  description: 'Group plan for 5 or more. Order food with at least 4
  other individuals to take advantage of our better group rate.
  Simply share the given group code with at least 4 other individuals.
  These individuals will place their own orders and type in the group
  code during their individual checkout process. The group code
  must be used on all five orders, and the food must all be delivered
  to the same address to take advantage of the discount pricing. '
)

option_3.update_attributes(
  short_description: '$10/day $200/month',
  description: '20 daily deliveries for 20 delivery days from your start date.
  This plan covers up to $10 of choices from our menu.
  Any amount above your option plan will be charged accordingly.',
  shipping_fee: 40,
  shipping_note: '$40 Flat Monthly Delivery Fee.'
)

option_4.update_attributes(
  short_description: 'One-Time Order <br> $25 Minimum order. ',
  description: 'Any order below the minimum order will be billed at $25.',
  shipping_fee: 5,
  shipping_note: '$5 Delivery Charge'
)