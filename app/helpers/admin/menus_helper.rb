module Admin::MenusHelper

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
