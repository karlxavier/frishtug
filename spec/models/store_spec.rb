# == Schema Information
#
# Table name: stores
#
#  id               :bigint(8)        not null, primary key
#  _id              :integer
#  _code            :string
#  status           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  home_page_images :text
#

require 'rails_helper'

RSpec.describe Store, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
