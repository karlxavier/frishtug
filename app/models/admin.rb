class Admin < ApplicationRecord
  devise :database_authenticatable, :trackable, :timeoutable, :lockable
  validates :email, presence: true
  validates :email, uniqueness: true
end
