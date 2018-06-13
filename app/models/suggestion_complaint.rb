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

class SuggestionComplaint < ApplicationRecord
	enum type: { suggestion: 'suggestion', complaint: "complaint", }

	validates :email, :message, presence: true

end
