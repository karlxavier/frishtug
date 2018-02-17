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
end
