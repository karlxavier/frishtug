class AddOnsWorker
  include Sidekiq::Worker

  def perform(menu_ids, add_ons)
    index = 0
    Menu.transaction do
      while index < menu_ids.size
        menu = find_menu(menu_ids[index])
        menu.add_on_ids = find_or_create_add_ons_return_ids(add_ons[index], menu)
        index += 1
      end
    end
  end

  private

  def find_menu(menu_id)
    Menu.find(menu_id)
  end

  def find_or_create_add_ons_return_ids(add_ons, menu)
    return nil if add_ons.blank?
    menu_category = menu.menu_category
    add_on_ids = []
    add_ons.split('|').each do |add_on|
      query = add_on_query(add_on)
      add_on_ids << menu_category.add_ons.where(query).first_or_create(query).id
    end
    add_on_ids
  end

  def add_on_query(item)
    add_on = item.strip.split(':')
    category = MenuCategory.find_by_name('Add-Ons')
    menu_id = Menu.where('lower(name) = lower(?)', add_on[0].strip).first&.id
    if menu_id.present? || add_on.size == 1
      return {
        name: add_on[0].titleize,
        menu_id: menu_id
      }
    else
      menu = Menu.create!(
        name: add_on[0],
        price: add_on[1].to_d,
        menu_category_id: category.id,
        published_at: Time.current,
        published: true,
        unit_id: 8,
        unit_size: 1,
        description: 'Add On',
        asset_id: nil,
        notes: nil,
        tax: false,
        diet_category_ids: [],
        add_on_ids: [],
        item_number: SecureRandom.hex(5),
        inventory_attributes: {
          quantity: 100,
          id: nil
        }
      )
      return {
        name: add_on[0].titleize,
        menu_id: menu.id
      }
    end
  end
end
