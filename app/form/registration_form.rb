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
                :start_date # Delivery Params

  validates :first_name, :last_name, :email, :password, :plan_id, presence: true
  validates :line1, :line2, :city, :state, :zip_code, presence: true
  validates :option, :schedule, :start_date, presence: true

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def persist!
    user = User.create!(user_params)
    user.addresses.create!(address_params)
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
end
