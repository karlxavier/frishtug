# frozen_string_literal: true

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
  validates :stripe_token, :addresses, :orders, presence: true

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
    user.create_schedule!(schedule_params) if user.plan.interval === 'month'
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
    orders.each do |param|
      if param[:order_date].present?
        param[:placed_on] = Time.zone.parse(param[:order_date])
        param[:order_date] = Time.current
        order = user.orders.create!(param)
        order.processing!
        excess = OrderCalculator.new(order).total_excess(user.plan.limit)
        tax = OrderCalculator.new(order).total_tax
        total = OrderCalculator.new(user.orders.first).total

        order.bill_histories.create!(
          user_id: user.id,
          amount_paid: excess,
          description: "Excess Charge",
          billed_at: Time.current
        ) if excess >= 0.50 && user.plan.interval == 'month'

        order.bill_histories.create!(
          user_id: user.id,
          amount_paid: tax,
          description: "Tax Charge",
          billed_at: Time.current
        ) if tax >= 0.50 && user.plan.interval == 'month'

        order.bill_histories.create!(
          user_id: user.id,
          amount_paid: total,
          description: "Order Charge",
          billed_at: Time.current
        ) if total >= 0.50 && user.plan.interval != 'month'
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
      check_tax_and_charge(user)
    else
      create_a_charge(user)
      check_tax_and_charge(user)
    end
  end

  def create_a_charge(user)
    amount_to_pay = OrderCalculator.new(user.orders.first).total
    amount_to_pay = user.plan.minimum_charge > amount_to_pay ? user.plan.minimum_charge : amount_to_pay
    raise amount_to_pay.to_f.inspect
    charge = StripeCharger.new(user, amount_to_pay)
    if charge.run
      user.bill_histories.create!(
        amount_paid: amount_to_pay,
        description: 'Single Order Charge!',
        billed_at: Time.current
      )
    else
      errors.add(:base, charge.errors.full_message.join(', '))
      raise ActiveRecord::StatementInvalid
    end
  end

  def create_subscription(user)
    stripe_subscription = StripeSubscriptioner.new(user)
    if stripe_subscription.run
      user.approved = true
      user.save
      user.bill_histories.create!(
        amount_paid: user.plan.price,
        description: 'Subscription Payment!',
        billed_at: Time.current
      )
    else
      errors.add(:base, stripe_subscription.errors.full_messages.join(', '))
      raise ActiveRecord::StatementInvalid
    end
  end

  def check_limit_and_charge(user)
    plan_limit = user.plan.limit
    excess_amount = OrderCalculator.new(user.orders).get_excess(plan_limit)
    return if excess_amount < 0.50 || excess_amount.zero?
    ExcessChargeWorker.perform_at(user.orders.first.placed_on, user.id, excess_amount)
  end

  def check_tax_and_charge(user)
    tax_amount = OrderCalculator.new(user.orders).total_orders_tax
    return if tax_amount < 0.50 || tax_amount.zero?
    TaxChargeWorker.perform_at(user.orders.first.placed_on, user.id, tax_amount)
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
