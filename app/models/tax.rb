# == Schema Information
#
# Table name: taxes
#
#  id         :bigint(8)        not null, primary key
#  rate       :float
#  store_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tax < ApplicationRecord
  belongs_to :store
  validates :rate, presence: true, numericality: true
end
