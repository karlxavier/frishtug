# Handles multiple image upload using image url's
# Ids is an array that contains Menu id for updating
class ImageWorker
  include Sidekiq::Worker

  def perform(ids, image_urls)
    ids.each_with_index do |id, index|
      menu = Menu.find(id)
      menu.remote_image_url = image_urls[index]
      Menu.transaction do
        raise "Menu image cannot be save, #{menu.to_param}" unless menu.save
      end
    end
  end
end
