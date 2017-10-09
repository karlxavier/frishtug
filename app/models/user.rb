class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates :first_name, :last_name, presence: true
  has_many :address, as: :addressable
  belongs_to :plan, optional: true
end
