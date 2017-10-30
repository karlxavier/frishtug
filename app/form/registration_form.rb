class RegistrationForm
  include ActiveModel::Model

  attr_accessor :first_name,
                :last_name,
                :email,
                :password,
                :plan_id, # User params
                :location_at,
                :line1,
                :line2,
                :front_door,
                :city,
                :state,
                :zip_code, # Address params
                :group_code,
                :option,
                :schedule,
                :start_date, # Delivery Params
                :phone_number, # Contact number params
                :bank_name,
                :account_number,
                :routing_number,
                :card_number,
                :month,
                :year,
                :cvc,
                :payment_method,
                :orders,
                :billing_line_1,
                :billing_line_2,
                :billing_city,
                :billing_state,
                :billing_zip_code,
                :billing_phone_number

  validates :first_name, :last_name, :email, :password, presence: true
  validates :location_at, :line1, :line2, :city, :state, :zip_code, presence: true
  validates :phone_number, presence: true
  # validates :option, :schedule, :start_date, presence: true
  validate :user_email_unique?
  validates :bank_name, :account_number, :routing_number, presence: true, if: :checking?
  validates :card_number, :month, :year, :cvc, presence: true, if: :credit_card?

  def save
    return false if invalid?
    persist!
  end

  def address_types
    %i[at_work at_home multiple_workplaces]
  end

  def schedule_types
    %i[monday_to_friday sunday_to_thursday]
  end

  def schedule_days(type)
    Scheduler.new(type).run
  end

  def payment_methods
    %i[credit_card checking]
  end

  private

  def checking?
    payment_method == :checking
  end

  def credit_card?
    payment_method == :credit_card?
  end

  def user_email_unique?
    return false unless User.where(email: email).exists?
    errors.add(:email, 'Email is already in use.')
  end

  def persist!
    ActiveRecord::Base.transaction do
      user = User.create!(user_params)
      user.addresses.create!(address_params)
      user.create_contact_number!(phone_number: phone_number)
      user.create_schedule!(schedule_params)
      orders.each do |o|
        order = user.orders.create!(placed_on: o['order_date'])
        order.menu_ids = o['menu_ids'][0].split(',')
      end
    end

    true
  rescue ActiveRecord::StatementInvalid => e
    # e.message and e.cause.message  can be helpful
    errors.add(:base, e.message)

    false
  end

  def user_params
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      password: password,
      plan_id: plan_id
    }
  end

  def address_params
    {
      location_at: location_at,
      line1: line1,
      line2: line2,
      front_door: front_door,
      city: city,
      state: state,
      zip_code: zip_code
    }
  end

  def schedule_params
    {
      option: schedule,
      start_date: start_date
    }
  end

  def credit_card_params
    {
      number: card_number,
      month: month,
      year: year,
      cvc: cvc
    }
  end

  def checking_account_params
    {
      bank_name: bank_name,
      account_number: account_number,
      routing_number: routing_number
    }
  end
end
