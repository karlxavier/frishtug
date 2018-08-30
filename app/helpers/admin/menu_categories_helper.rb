module Admin::MenuCategoriesHelper
  def is_part_of_plan?(menu_category)
    if menu_category.part_of_plan
      content_tag :i, nil, class: 'fa fa-check text-success'
    else
      content_tag :i, nil, class: 'fa fa-times text-danger'
    end
  end

  def display_ordering_select_box(menu_category)
    category_size = MenuCategory.count
    select_tag "display_order",
      options_for_select((1..category_size).map { |n| [n, n] }, selected: menu_category.display_order),
      class: 'form-control display_order_selection',
      include_blank: true,
      data: { id: menu_category.id }
  end

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
