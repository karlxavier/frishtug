Admin.create(email: 'admin@frishtug.com', password: 'frishtug2017!')

%w[ounce pound milligram gram kilogram liter cup].each do |name|
  Unit.create(name: name)
end

# ['Bread - Rolls', 'Salads - Smears',
#  'Vegetables', 'Side Dishes',
#  'Drinks', 'Ready Sandwiches'].each do |name|
#   MenuCategory.create(name: name)
# end

['Sugar Free', 'Gluten Free', 'Carb Free', 'May Contain Allergens'].each do |name|
  DietCategory.create(name: name)
end

# Plan.delete_all
Plan.create([
  {
    name: "Option 1",
    description:
      "<div>20 daily deliveries. Just choose your start date. This plan covers up to $20 of choices from our menu. Any amount above your option plan will be charged accordingly.</div>",
    price: 0.4e3,
    shipping: "free",
    shipping_fee: nil,
    note:
      "Incididunt esse elit magna incididunt nulla. Sunt ipsum eu cillum nisi officia labore. Anim ullamco esse nulla aliqua minim officia elit sint nostrud occaecat velit sint.",
    shipping_note: "",
    interval: "month",
    users_count: 70,
    for_type: "individual",
    short_description: "$20/day. $400/month",
    limit: 0.2e2,
    minimum_credit_allowed: 0.15e2,
    minimum_charge: 0.0,
    shipping_charge_type: "not_available"
  },
  {
    name: "Option 2",
    description:
      "<div>Group plan for 5 or more. Order food with at least 4 other individuals to take advantage of our better group rate. Simply share the given group code with at least 4 other individuals. These individuals will place their own orders and type in the group code during their individual checkout process. The group code must be used on all five orders, and the food must all be delivered to the same address to take advantage of the discount pricing.&nbsp;</div>",
    price: 0.299e3,
    shipping: "free",
    shipping_fee: nil,
    note: "Voluptate ipsum ipsum cupidatat amet sint ea. Reprehenderit deserunt consectetur veniam sunt dolore.",
    shipping_note: "",
    interval: "month",
    users_count: 42,
    for_type: "group",
    short_description: "$14.95/day $299/month",
    limit: 0.1495e2,
    minimum_credit_allowed: 0.1e2,
    minimum_charge: 0.0,
    shipping_charge_type: "not_available"
  },
  {
    name: "Option 3",
    description:
      "<div>20 daily deliveries for 20 delivery days from your start date. This plan covers up to $10 of choices from our menu. Any amount above your option plan will be charged accordingly.</div>",
    price: 0.2e3,
    shipping: "paid",
    shipping_fee: 0.4e2,
    note: "Dolor occaecat commodo nostrud culpa deserunt. Aliqua nisi voluptate cillum aliquip proident commodo ea irure Lorem anim ut.",
    shipping_note: "$40 Flat Monthly Delivery Fee.",
    interval: "month",
    users_count: 23,
    for_type: "individual",
    short_description: "$10/day $200/month",
    limit: 0.1e2,
    minimum_credit_allowed: 0.5e1,
    minimum_charge: 0.0,
    shipping_charge_type: "per_month"
  },
  {
    name: "Option 4",
    description: "<div>Any order below the minimum order will be billed at $25.</div>",
    price: 0.25e2,
    shipping: "paid",
    shipping_fee: 0.5e1,
    note: "Mollit eiusmod est est commodo qui. Laboris enim laboris qui sunt quis consectetur laboris minim dolor anim irure ut esse in.",
    shipping_note: "$5 Delivery Charge",
    stripe_plan_id: nil,
    interval: "",
    users_count: 22,
    for_type: "individual",
    short_description: "One-Time Order <br> $25 Minimum order. ",
    limit: nil,
    minimum_credit_allowed: nil,
    minimum_charge: 0.25e2,
    shipping_charge_type: "per_order"
  },
  {
    name: "Option 4-b",
    description:
      "<div>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</div><div><br></div>",
    price: 0.25e2,
    shipping: "paid",
    shipping_fee: 0.0,
    note: nil,
    shipping_note: "Shipping is separate",
    stripe_plan_id: nil,
    interval: "",
    users_count: 1,
    for_type: "party_meeting",
    short_description: "Party Meeting Plan",
    limit: nil,
    minimum_credit_allowed: nil,
    minimum_charge: 0.25e2,
    shipping_charge_type: "per_order"
  }
])


# Create a stripe subscription plan and update plan
StripePlanner.new(Plan.first).run
StripePlanner.new(Plan.second).run
StripePlanner.new(Plan.third).run

AllowedZipCode.create([
  { zip: "10901" },
  { zip: "10952" },
  { zip: "10956" },
  { zip: "10960" },
  { zip: "10954" },
  { zip: "10977" },
  { zip: "10970" },
  { zip: "10982" },
  { zip: "10950" },
  { zip: "10930" },
])