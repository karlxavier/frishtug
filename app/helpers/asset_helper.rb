module AssetHelper
  def asset_image_tag(asset, options = {})
    options[:fetch_format] = :auto
    options[:quality] = :auto
    cl_image_tag asset.image, options
  end

  def plan_image_path(plan)
    asset_pack_path "packs/images/#{p.name.downcase.split(" ").join}.png"
  rescue
    asset_pack_path "packs/images/option4.png"
  end
end
