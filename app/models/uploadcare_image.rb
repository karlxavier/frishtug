class UploadcareImage
  include Virtus.model
  include ActiveModel::Model
  include HTTParty

  base_uri 'api.uploadcare.com'
  debug_output $stdout unless Rails.env.production?

  class Info
    include Virtus.model

    attribute :height, Integer
    attribute :width, Integer
    attribute :geo_location
    attribute :datetime_original
    attribute :format, String
  end

  attribute :uuid, String
  attribute :mime_type, String
  attribute :is_ready, Boolean
  attribute :original_filename, String
  attribute :original_file_url, String
  attribute :datetime_uploaded, String
  attribute :size, Integer
  attribute :datetime_stored, String
  attribute :source, Hash
  attribute :image_info, UploadcareImage::Info

  def ==(img)
    uuid = img.uuid
  end
  alias eql? ==

  def url
    return unless uuid
    "https://ucarecdn.com/#{uuid}/"
  end

  def formatted_url(url_operations_str = nil)
    return unless url.present?
    "#{url}#{url_operations_str}"
  end

  def destroy
    self.class.delete("/files/#{uuid}/", headers: self.class.headers)
  end

  def self.find(uuid)
    return unless uuid.present?
    response = get("/files/#{uuid}/", headers: headers)
    UploadcareImage.new(
      JSON.parse(response.body)
        .with_indifferent_access
        .slice(*UploadcareImage.attributes.map(&:name))
    )
  end

  class << self
    def uuid_from_url(url)
      return unless url.present?
      url.split('/')[3]
    end

    def formatted_url_from_uuid(uuid, url_operations_str = nil)
      new(uuid: uuid).formatted_url(url_operations_str)
    end

    def headers
      {
        'Accept' => 'application/vnd.uploadcare-v0.4+json',
        'Authorization' => "Uploadcare.Simple #{config[:defaults][:public_key]}:#{config[:defaults][:private_key]}",
        'Date' => Time.current.rfc2822.to_s
      }
    end

    def config
      conf ||= YAML.load_file("#{Rails.root}/config/uploadcare.yml")
                   .with_indifferent_access
      conf
    end
  end
end
