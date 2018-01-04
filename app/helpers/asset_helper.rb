module AssetHelper

  def asset_image_tag(asset, options = {})
    options[:fetch_format] = :auto
    options[:quality] = :auto
    cl_image_tag asset.image, options
  end
end
