module Admin::MenusHelper

  def add_add_ons_link(menu_category)
    return nil unless menu_category.add_ons.blank?
    content_tag :small do
      link_to 'Create a new add-on for this category',
        edit_admin_menu_category_path(menu_category)
    end
  end

  def menu_asset_image(menu)
    if menu.asset_id?
     content_tag :div, class: 'dz-preview' do
      content_tag :div, class: 'dz-image' do
        cl_image_tag menu.asset.image.medium, height: 120
      end
     end
    end
  end

  def display_menu_ordering_select_box(menu)
    menu_size = MenuCategory.find_by_id(menu.menu_category_id)&.menus&.size || 0
    select_tag "display_order",
      options_for_select((1..menu_size).map { |n| [n, n] }, selected: menu.display_order),
      class: 'py-1 px-2 bg-white display_order_selection rounded',
      include_blank: true,
      onchange: "update_menu_display_order(this.value, #{menu.id})"
  end
end
