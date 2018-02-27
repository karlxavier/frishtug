# == Schema Information
#
# Table name: search_results
#
#  searchable_id   :integer
#  searchable_type :text
#  term            :string
#

class SearchResult < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true
  def readonly?
    true
  end
end
