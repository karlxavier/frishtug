class SuggestionComplaint < ApplicationRecord
	enum type: { suggestion: 'suggestion', complaint: "complaint", }

	validates :email, :message, presence: true

end
