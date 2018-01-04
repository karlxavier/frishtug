module PagesHelper
  def image_asset(obj, options = {})
    return nil unless obj.asset_id?
    options[:fetch_format] = :auto
    options[:quality] = :auto
    cl_image_tag obj.asset.image, options
  end

  def random_background
    assets = Store.first.assets
    return nil unless assets.present?
    cl_image_path(assets.sample(1).first.image, fetch_format: :auto, quality: :auto)
  end
end
