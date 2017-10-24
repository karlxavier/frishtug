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

Plan.delete_all
Plan.create([
  {
    name: 'Option 1',
    description: '$20 per day, at $400 monthly',
    price: 20,
    shipping: :free,
    note: 'Incididunt esse elit magna incididunt nulla. Sunt ipsum eu cillum nisi officia labore. Anim ullamco esse nulla aliqua minim officia elit sint nostrud occaecat velit sint.'
  },
  {
    name: 'Option 2',
    description: '$14.95 x 20 days = $299',
    price: 14.95,
    shipping: :free,
    note: 'Voluptate ipsum ipsum cupidatat amet sint ea. Reprehenderit deserunt consectetur veniam sunt dolore.'
  },
  {
    name: 'Option 3',
    description: '$10 per day, at $200 monthly',
    price: 10,
    shipping: :paid,
    shipping_fee: 40,
    shipping_note: 'Additional $40 for Delivery',
    note: 'Dolor occaecat commodo nostrud culpa deserunt. Aliqua nisi voluptate cillum aliquip proident commodo ea irure Lorem anim ut.'
  },
  {
    name: 'Option 4',
    description: 'Single breakfast at $25',
    price: 25,
    shipping: :paid,
    shipping_fee: 40,
    shipping_note: 'Delivery will be xx USD',
    note: 'Mollit eiusmod est est commodo qui. Laboris enim laboris qui sunt quis consectetur laboris minim dolor anim irure ut esse in.'
  }
])
