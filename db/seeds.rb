Admin.create(email: 'admin@frishtug.com', password: 'frishtug2017!')

%w[ounce pound milligram gram kilogram liter cup].each do |name|
  Unit.create(name: name)
end

['Bread - Rolls', 'Salads - Smears',
 'Vegetables', 'Side Dishes',
 'Drinks', 'Ready Sandwiches'].each do |name|
  MenuCategory.create(name: name)
end

['Sugar Free', 'Gluten Free', 'Carb Free', 'May Contain Allergens'].each do |name|
  DietCategory.create(name: name)
end
