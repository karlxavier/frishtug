module PagesHelper
  def image_asset(obj, options = {})
    return nil unless obj.asset_id?
    cl_image_tag obj.asset.image, options
  end

  def random_background
    assets = Store.first.assets
    return nil unless assets.present?
    assets.sample(1).first.image
  end
end
