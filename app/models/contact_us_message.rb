class ContactUsMessage < ApplicationRecord
  validates :email, :first_name, :last_name, presence: true

  def full_name
    [first_name, last_name].join(' ')
  end
end
