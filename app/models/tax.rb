# == Schema Information
#
# Table name: taxes
#
#  id         :integer          not null, primary key
#  rate       :float
#  store_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tax < ApplicationRecord
  belongs_to :store
end
