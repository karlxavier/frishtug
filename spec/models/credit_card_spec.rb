# == Schema Information
#
# Table name: credit_cards
#
#  id         :integer          not null, primary key
#  number     :string
#  month      :integer
#  year       :integer
#  cvc        :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  brand      :string
#  token      :string
#

require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
