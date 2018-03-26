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
  belongs_to :user, -> { where( search_results: { searchable_type: 'User'} ).includes(:search_results) }, foreign_key: 'searchable_id'
  belongs_to :order, -> { where( search_results: { searchable_type: 'Order'} ).includes(:search_results) }, foreign_key: 'searchable_id'
  belongs_to :menu, -> { where( search_results: { searchable_type: 'Menu'} ).includes(:search_results) }, foreign_key: 'searchable_id'

  def readonly?
    true
  end

  def self.search(search_term)
    includes(:user, :order, :menu).where("term ILIKE ?", "%#{search_term}%")
  end
end
