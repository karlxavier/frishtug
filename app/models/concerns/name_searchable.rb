module NameSearchable
  extend ActiveSupport::Concern

  included do
    scope :name_exists?, ->(name) { where('lower(name) = ?', name) }
    scope :search_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
  end
end
