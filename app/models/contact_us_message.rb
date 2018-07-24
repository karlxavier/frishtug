class ContactUsMessage < ApplicationRecord
  default_scope { order(created_at: :desc)}
  validates :email, :first_name, :last_name, presence: true

  def full_name
    [first_name, last_name].join(' ')
  end
end
