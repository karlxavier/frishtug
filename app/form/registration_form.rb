class RegistrationForm
  include ActiveModel::Model

  attr_accessor :first_name,
                :last_name,
                :email,
                :password,
                :plan_id, # User params
                :addresses,
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
                :billing_phone_number,
                :stripe_token,
                :card_brand

  validates :first_name, :last_name, :email, :password, presence: true
  validates :phone_number, presence: true
  # validates :option, :schedule, :start_date, presence: true
  validate :user_email_unique?
  validates :bank_name, :account_number, :routing_number, presence: true, if: :checking?
  validates :card_number, :month, :year, :cvc, presence: true, if: :credit_card?
  validates :stripe_token, presence: true

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
    errors.add(:email, 'is already registered.')
  end

  def persist!
    ActiveRecord::Base.transaction do
      user = User.create!(user_params)
      create_user_info(user)
      create_orders(user)
      save_and_charge_payment(user)
    end
    true
  rescue ActiveRecord::StatementInvalid => e
    # e.message and e.cause.message  can be helpful
    errors.add(:base, e.message)

    false
  rescue ActiveRecord::Rollback => e
    # e.message and e.cause.message  can be helpful
    errors.add(:base, e.message)

    false
  end

  def create_user_info(user)
    addresses.each do |a|
      user.addresses.create!(address_params(a))
    end
    user.create_contact_number!(phone_number: phone_number)
    user.create_schedule!(schedule_params)
  end

  def create_orders(user)
    orders.each do |o|
      if o[:order_date].present?
        order = user.orders.create!(placed_on: o[:order_date])
        order.menu_ids = o[:menu_ids][0].split(',')
      else
        errors.add(:base, 'Order place on is blank')
        raise ActiveRecord::Rollback
      end
    end
  end

  def save_and_charge_payment(user)
    payment_method.classify.constantize.create!(
      payment_method_params.merge!(user_id: user.id)
    )
    if user.plan.interval == 'month'
      create_subscription(user)
    else
      create_a_charge(user)
    end
  end

  def create_a_charge(user)
    amount_to_pay = user.orders.first.menus.map(&:price).inject(:+)
    charge = StripeCharger.new(user, amount_to_pay)
    charge.run
    unless charge.errors.empty?
      errors.add(:base, charge.errors.full_message.join(', '))
      raise ActiveRecord::Rollback
    end
  end

  def create_subscription(user)
    stripe_subscription = StripeSubscriptioner.new(user)
    if stripe_subscription.run
      user.approved = true
      user.save
    else
      errors.add(:base, stripe_subscription.errors.full_messages.join(', '))
      raise ActiveRecord::Rollback
    end
  end

  def user_params
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      password: password,
      password_confirmation: password,
      plan_id: plan_id,
      stripe_token: stripe_token
    }
  end

  def address_params(address)
    {
      location_at: address[:location_at],
      line1: address[:line1],
      line2: address[:line2],
      front_door: address[:front_door],
      city: address[:city],
      state: address[:state],
      zip_code: address[:zip_code]
    }
  end

  def schedule_params
    {
      option: schedule,
      start_date: start_date
    }
  end

  def payment_method_params
    send("#{payment_method}_params")
  end

  def credit_card_params
    {
      number: "****#{card_number.last(4)}",
      month: month,
      year: year,
      cvc: cvc,
      brand: card_brand,
      token: stripe_token
    }
  end

  def checking_params
    {
      bank_name: bank_name,
      account_number: account_number,
      routing_number: routing_number,
      token: stripe_token
    }
  end
end
