class DietCategoryWorker
  include Sidekiq::Worker

  def perform(menu_ids, diet_categories)
    index = 0
    Menu.transaction do
      while index < menu_ids.size
        menu = find_menu(menu_ids[index])
        menu.diet_category_ids = diet_category_ids(diet_categories[index])
        index += 1
      end
    end
  end

  private

  def find_menu(id)
    Menu.find(id)
  end

  def diet_category_ids(diet_categories)
    DietCategory.where(name: to_array(diet_categories)).map(&:id)
  end

  def to_array(diet_categories)
    diet_categories.split('|') unless diet_categories.nil?
  end
end