# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string           default(""), not null
#  encrypted_password      :string           default(""), not null
#  reset_password_token    :string
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0), not null
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :inet
#  last_sign_in_ip         :inet
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  first_name              :string
#  last_name               :string
#  plan_id                 :integer
#  stripe_token            :string
#  subscribe_at            :datetime
#  subscription_expires_at :datetime
#  stripe_customer_id      :string
#  stripe_subscription_id  :string
#  approved                :boolean          default(FALSE), not null
#

class User < ApplicationRecord
  include Groupable
  has_many :user_notifications, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  has_many :checkings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :search_results, as: :searchable
  has_one  :contact_number, dependent: :destroy
  has_one  :schedule, dependent: :destroy
  belongs_to :plan, optional: true, counter_cache: true
  has_many :orders, dependent: :destroy
  has_many :bill_histories, dependent: :destroy
  has_many :temp_orders, dependent: :destroy
  has_many :pending_credits, dependent: :destroy
  has_one :referrer, dependent: :destroy
  has_one :candidate, dependent: :destroy
  has_one :order_preference, dependent: :destroy
  has_many :ledgers, dependent: :destroy
  has_many :tax_ledgers, dependent: :destroy
  has_many :additional_ledgers, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  accepts_nested_attributes_for :contact_number

  delegate :name, :id, :price, to: :plan, prefix: true, allow_nil: true
  delegate :phone_number, :id, to: :contact_number, prefix: true, allow_nil: true

  after_create :delete_inactive_entry!

  def self.in_locations(locations)
    joins(:addresses).merge(Address.search_list(locations))
  end

  def self.in_location(location)
    joins(:addresses).merge(Address.search(location))
  end

  def self.search(search_term)
    term = "%#{search_term}%"
    includes(:plan, :contact_number)
      .where('last_name ILIKE ? OR first_name ILIKE ?', term, term)
  end

  def active_address
    addresses.active.first
  end

  def full_name
    "#{first_name} #{last_name}".titleize
  end

  def payment_information
    entries = []
    if checkings.present?
      checkings.each do |c|
        entries.push c
      end
    end

    if credit_cards.present?
      credit_cards.each do |cc|
        entries.push cc
      end
    end

    entries
  end

  def full_address
    <<-EOF
      #{addresses.active.first.line1}
      #{addresses.active.first.line2}
      #{addresses.active.first.city}
      #{addresses.active.first.state}
      #{addresses.active.first.zip_code}
    EOF
  end

  def street_address
    [active_address.line1, active_address.line2].reject(&:blank?).join(', ').strip
  end

  def set_default_source(source)
    StripeCustomer.new(self).set_default_source(source)
  end

  def subscribed?
    return false unless plan
    plan.interval == 'month'
  end

  def orders_completed?
    counter = orders.where(status: [:processing, :completed, :cancelled]).count
    return false if counter.zero?
    counter % 20 == 0
  end

  def has_fresh_orders?
    orders.fresh.count > 0
  end

  private

    def delete_inactive_entry!
      InactiveUser.find_by_email(self.email)&.destroy
    end
end
