namespace :process_add_ons do
  task run: :environment do
    add_ons = AddOn.all
    quantity = 100
    add_ons_category = MenuCategory.find_by_name('Add-Ons')
    current_time = Time.current
    add_ons.each do |a|
      args = a.name.split(':')
      if args.size == 2
        has_menu = Menu.where(name: args.first)
        if has_menu.present?
          a.update_attributes(name: args.first, menu_id: has_menu.first.id)
        else
          menu = Menu.new(
            name: args.first,
            price: args.last.to_d,
            menu_category_id: add_ons_category.id,
            published_at: current_time,
            published: true,
            unit_id: 8,
            unit_size: 1,
            description: 'Add On',
            asset_id: nil,
            notes: nil,
            tax: false,
            diet_category_ids: [],
            add_on_ids: [],
            item_number: args.first.parameterize.gsub(' ', ''),
            inventory_attributes: {
              quantity: quantity,
              id: nil
            }
          )
          a.update_attributes(name: args.first, menu_id: menu.id)
        end
      else
        next
      end
    end
  end
end
