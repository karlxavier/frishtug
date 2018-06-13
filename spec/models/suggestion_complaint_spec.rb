# == Schema Information
#
# Table name: suggestion_complaints
#
#  id         :bigint(8)        not null, primary key
#  email      :string
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :integer          default(NULL)
#

require 'rails_helper'

RSpec.describe SuggestionComplaint, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
