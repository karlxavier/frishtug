class RegistrationForm
  include ActiveModel::Model

  attr_accessor :first_name,
                :last_name,
                :email,
                :password,
                :plan_id, # User params
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
                :number,
                :month,
                :year,
                :cvc,
                :payment_method

  enum payment_method: %i[credit_card checking]

  validates :first_name, :last_name, :email, :password, presence: true
  validates :line1, :line2, :city, :state, :zip_code, presence: true
  validates :phone_number, presence: true
  # validates :option, :schedule, :start_date, presence: true
  validate :user_email_is_unique
  validates :bank_name, :account_number, :routing_number, if: :checking?
  validates :number, :month, :year, :cvc, if: :credit_card?

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def checking?
    payment_method.checking?
  end

  def credit_card?
    payment_method.credit_card?
  end

  def user_email_is_unique
    return false unless User.where(email: email).exists?
    errors.add(:email, 'Email is already in use.')
  end

  def persist!
    user = User.create!(user_params)
    user.addresses.create!(address_params)
    user.contact_number.create!(phone_number: phone_number)
    user.delivery.create!(delivery_params)
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
      line1: line1,
      line2: line2,
      front_door: front_door,
      city: city,
      state: state,
      zip_code: zip_code
    }
  end

  def delivery_params
    {
      option: option,
      schedule: schedule,
      start_date: start_date
    }
  end

  def credit_card_params
    {
      number: number,
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
