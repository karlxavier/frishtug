namespace :setup_frishtug do
  desc "Setup for frishtug"
  task run: :environment do
    # Admin Account
    Admin.create(email: 'admin@frishtug.com', password: 'frishtug2017!')

    # Unit
    %w[ounce pound milligram gram kilogram liter cup].each do |name|
      Unit.create(name: name)
    end

    # Diet Categories
    [
      'Sugar Free',
      'Gluten Free',
      'Carb Free',
      'May Contain Allergens'
    ].each do |name|
        DietCategory.create(name: name)
    end

    # Menu Categories
    [
      'Bread Rolls',
      'Salads/Smears',
      'Vegetables',
      'Side Dishes',
      'Drinks',
      'Snacks',
      'Lunch',
      'Ready Sandwiches',
      'Add-Ons'
    ].each do |name|
      MenuCategory.create(
        name: name,
        display_order: name != 'Add-Ons' ? index+1 : nil,
        part_of_plan: name != 'Add-Ons' ? true : false )
    end

    # Allowed Zip Codes
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

    # Generate Plans
    [
      {
        "name": "Option 1",
        "description": "<div>20 daily deliveries. Just choose your start date. This plan covers up to $20 of choices from our menu. Any amount above your option plan will be charged accordingly.</div>",
        "price": 400.0,
        "shipping": "free",
        "created_at": "2017-12-04 05:31:57 -0500",
        "updated_at": "2018-02-13 01:24:34 -0500",
        "shipping_fee": nil,
        "note": "Incididunt esse elit magna incididunt nulla. Sunt ipsum eu cillum nisi officia labore. Anim ullamco esse nulla aliqua minim officia elit sint nostrud occaecat velit sint.",
        "shipping_note": "",
        "stripe_plan_id": "option-1",
        "interval": "month",
        "users_count": 43,
        "for_type": "individual",
        "short_description": "$20/day. $400/month",
        "limit": 20.0,
        "minimum_credit_allowed": 15.0
      },
      {
        "name": "Option 2",
        "description": "<div>Group plan for 5 or more. Order food with at least 4 other individuals to take advantage of our better group rate. Simply share the given group code with at least 4 other individuals. These individuals will place their own orders and type in the group code during their individual checkout process. The group code must be used on all five orders, and the food must all be delivered to the same address to take advantage of the discount pricing.&nbsp;</div>",
        "price": 299.0,
        "shipping": "free",
        "created_at": "2017-12-04 05:31:58 -0500",
        "updated_at": "2018-02-13 01:24:44 -0500",
        "shipping_fee": nil,
        "note": "Voluptate ipsum ipsum cupidatat amet sint ea. Reprehenderit deserunt consectetur veniam sunt dolore.",
        "shipping_note": "",
        "stripe_plan_id": "option-2",
        "interval": "month",
        "users_count": 13,
        "for_type": "group",
        "short_description": "$14.95/day $299/month",
        "limit": 14.95,
        "minimum_credit_allowed": 10.0
      },
      {
        "name": "Option 3",
        "description": "<div>20 daily deliveries for 20 delivery days from your start date. This plan covers up to $10 of choices from our menu. Any amount above your option plan will be charged accordingly.</div>",
        "price": 200.0,
        "shipping": "paid",
        "created_at": "2017-12-04 05:31:58 -0500",
        "updated_at": "2018-02-13 01:24:54 -0500",
        "shipping_fee": 40.0,
        "note": "Dolor occaecat commodo nostrud culpa deserunt. Aliqua nisi voluptate cillum aliquip proident commodo ea irure Lorem anim ut.",
        "shipping_note": "$40 Flat Monthly Delivery Fee.",
        "stripe_plan_id": "option-3",
        "interval": "month",
        "users_count": 14,
        "for_type": "individual",
        "short_description": "$10/day $200/month",
        "limit": 10.0,
        "minimum_credit_allowed": 5.0
      },
      {
        "name": "Option 4",
        "description": "Any order below the minimum order will be billed at $25.",
        "price": 25.0,
        "shipping": "paid",
        "created_at": "2017-12-04 05:31:59 -0500",
        "updated_at": "2017-12-14 21:28:55 -0500",
        "shipping_fee": 5.0,
        "note": "Mollit eiusmod est est commodo qui. Laboris enim laboris qui sunt quis consectetur laboris minim dolor anim irure ut esse in.",
        "shipping_note": "$5 Delivery Charge",
        "stripe_plan_id": nil,
        "interval": nil,
        "users_count": 1,
        "for_type": "individual",
        "short_description": "One-Time Order <br> $25 Minimum order. ",
        "limit": nil,
        "minimum_credit_allowed": nil
      }
    ].each do |params|
      Plan.create(params)
    end

    # Create stripe plans
    Plans.where(name: ['Option 1', 'Option 2', 'Option 3']).each do |plan|
      StripePlanner.new(plan).run
    end

    # Store Configurations
    # This configurations are used in scanovator api
    store = Store.create!(
      _id: 41,
      _code: "jjW46G15XW5eYEg88UB7"
    )
    # Set tax to 6.3%
    store.create_tax(rate: 6.3)
  end
end
