class SearchResult < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true

  def readonly?
    true
  end
end