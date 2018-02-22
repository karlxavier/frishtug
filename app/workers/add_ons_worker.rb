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

  def add_on_query(entry)
    menu_id = Menu.where('lower(name) = lower(?)', entry.strip).first&.id
    return {
      name: entry.titleize,
      menu_id: menu_id
    }
  end
end
