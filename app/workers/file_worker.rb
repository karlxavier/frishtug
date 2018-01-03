class FileWorker
  include Sidekiq::Worker

  def perform(ids, image_urls)
    api = ::Rails.application.config.uploadcare.api
    ids.each_with_index do |id, index|
      menu = Menu.find(id)
      file = api.file image_urls[index]
      menu.image = file.cdn_url
      Menu.transaction do
        raise "Menu image cannot be save, #{menu.to_param}" unless menu.save
      end
    end
  end
end
