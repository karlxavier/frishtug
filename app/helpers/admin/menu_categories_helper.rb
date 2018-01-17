module Admin::MenuCategoriesHelper
  def display_all_add_ons(menu_category)
    return no_add_ons if menu_category.add_ons.blank?
    content_tag :span, class: 'd-block', style: truncatable_style do
      menu_category.add_ons.map(&:name).join(', ')
    end
  end

  private

  def no_add_ons
    content_tag :small, 'No Add-Ons', class: 'text-muted font-size-12'
  end

  def truncatable_style
    'width: 18rem; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;'
  end
end
