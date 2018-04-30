require 'active_merchant'
require 'active_merchant/billing/rails'

class SubscriptionProcessor
  include ActiveModel::Validations

  def initialize(user)
    @user = user
    @charge_amount = user.plan.price
    mode
  end

  def run
    if credit_card.valid?
      response = gateway.recurring(amount_to_cents, credit_card, options)

      if response.success?
        user.update_attributes(
          subscription_id: response.params['subscription_id'],
          customer_id: response.params['customer_profile_id'],
          customer_payment_id: response.params['customer_payment_profile_id']
        )
        true
      else
        errors.add(:base, response.message)
        false
      end
    else
      error_message = <<-EOF.squish
        Error: Credit card not valid.
        #{credit_card.errors.full_messages.join('.\n')}
      EOF
      errors.add(:base, error_message)
    end
  end

  def cancel
    return false unless subscribed?
    response = gateway.cancel_recurring(user.subscription_id)

    if response.success?
      true
    else
      errors.add(:base, response.message)
      false
    end
  end

  def update
    return false unless subscribed?
    options_with_subscription = option.merge!(subscription_id: user.subscription_id)
    response = gateway.update_recurring(options_with_subscription)

    if response.success?
      true
    else
      errors.add(:base, response.message)
      false
    end
  end

  private

  attr_accessor :charge_amount, :user

  def subscribed?
    unless user.subscription_id?
      errors.add(:base, 'User is not subscribe')
      return false
    end
    true
  end

  def options
    {
      amount: amount_to_cents,
      subscription_name: user.plan.name,
      credit_card: credit_card,
      billing_address: billing_address,
      interval: {
        unit: :months,
        length: 1
      },
      duration: {
        start_date: start_date,
        occurrences: 12
      }
    }
  end

  def start_date
    user.schedule.start_date&.strftime('%Y-%m-%d')
  end

  def mode
    ActiveMerchant::Billing::Base.mode = ENV['AUTHORIZENET_MODE'].to_sym
  end

  def gateway
    ActiveMerchant::Billing::AuthorizeNetArbGateway.new(
      login: ENV['AUTHORIZENET_LOGIN_ID'],
      password: ENV['AUTHORIZENET_TRANSACTION_KEY']
    )
  end

  def amount_to_cents
    (charge_amount * 100).to_i
  end

  def credit_card
    ActiveMerchant::Billing::CreditCard.new(
      number: user.credit_cards.first.number,
      month: user.credit_cards.first.month,
      year: user.credit_cards.first.year,
      first_name: user.first_name,
      last_name: user.last_name,
      verification_value: user.credit_cards.first.cvc,
      brand: 'visa'
    )
  end

  def billing_address
    address = if user.credit_cards.first.address.present?
                user.credit_cards.first.address
              else
                user.addresses.first
              end

    {
      first_name: user.first_name,
      last_name: user.last_name,
      address1: address.line1,
      city: address.city,
      state: address.state,
      country: 'US',
      zip: address.zip_code,
      phone: user.contact_number.phone_number
    }
  end
end
