module FileDeletable
  extend ActiveSupport::Concern

  included do
    before_destroy :destroy_uploaded_image
  end

  private

  def destroy_uploaded_image
    return unless self[:image].present?
    uuid = self[:image].split('/')[3]
    uploaded_image = UploadcareImage.find(uuid)
    uploaded_image.destroy
  end
end