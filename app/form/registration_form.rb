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
  validates :phone_number, :payment_method, presence: true
  validate  :user_email_unique?
  validates :bank_name, :account_number, :routing_number, presence: true, if: :checking?
  validates :card_number, :month, :year, :cvc, presence: true, if: :credit_card?
  validates :stripe_token, :addresses, :orders, :schedule, presence: true

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
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  def create_user_info(user)
    addresses.each_with_index do |address, index|
      add_params = address_params(address)
      add_params = add_params.merge!(status: :active) if index == 0
      user.addresses.create!(add_params)
    end

    user.create_contact_number!(phone_number: phone_number)
    if user.plan.for_type == 'group'
      create_referrer(user) unless group_code.present?
      create_candidate(user) if group_code.present?
    end

    user.create_schedule!(schedule_params)
  end

  def create_candidate(user)
    referrer = Referrer.find_by_group_code(group_code)
    if referrer
      user.create_candidate!(referrer_id: referrer.id)
    else
      errors.add(:base, "Group code does not exists for #{group_code}")
      raise ActiveRecord::StatementInvalid
    end
  end

  def create_referrer(user)
    user.create_referrer!(group_code: SecureRandom.urlsafe_base64(10))
  end

  def create_orders(user)
    orders.each do |_key, o|
      if o[:order_date].present?
        add_ons = o[:add_ons]
        order = user.orders.create!(order_date: Time.current, placed_on: o[:order_date])
        menu_ids_array = o[:menu_ids][0].split(',')
        quantities_array = o[:quantities][0].split(',')
        menu_ids_array.each_with_index do |id, index|
          add_on_ids = []
          add_on_ids = add_ons[index.to_s][:ids].split(',') if add_ons.present?
          order.menus_orders
               .create!(menu_id: id, quantity: quantities_array[index], add_ons: add_on_ids)
        end
        order.processing!
      else
        errors.add(:base, 'Order place on is blank')
        raise ActiveRecord::StatementInvalid
      end
    end
  end

  def save_and_charge_payment(user)
    payment_method.classify.constantize.create!(
      payment_method_params.merge!(user_id: user.id)
    )
    if user.plan.interval == 'month'
      create_subscription(user)
      check_limit_and_charge(user)
    else
      create_a_charge(user)
    end
  end

  def create_a_charge(user)
    amount_to_pay = OrderCalculator.new(user.orders.first).total
    charge = StripeCharger.new(user, amount_to_pay)
    charge.run
    unless charge.errors.empty?
      errors.add(:base, charge.errors.full_message.join(', '))
      raise ActiveRecord::StatementInvalid
    end
  end

  def create_subscription(user)
    stripe_subscription = StripeSubscriptioner.new(user)
    if stripe_subscription.run
      user.approved = true
      user.save
    else
      errors.add(:base, stripe_subscription.errors.full_messages.join(', '))
      raise ActiveRecord::StatementInvalid
    end
  end

  def check_limit_and_charge(user)
    plan_limit = user.plan.limit
    excess_amount = OrderCalculator.new(user.orders).get_excess(plan_limit)
    return if excess_amount < 0.50 || excess_amount == 0
    charge = StripeCharger.new(user, excess_amount)
    charge.charge_excess!
    unless charge.errors.empty?
      errors.add(:base, charge.errors.full_messages.join(', '))
      raise ActiveRecord::StatementInvalid
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
