class StripeCustomer
  include ActiveModel::Validations

  def initialize(user)
    @user = user
  end

  def create
    customer = stripe_create_customer
    @user.update_attributes(
      stripe_customer_id: customer.id
    )
    true
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false
  end

  def add_source(token)
    stripe_customer.sources.create(source: token)
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false
  end

  def remove_source(card_or_bank_id)
    stripe_customer.sources.retrieve(card_or_bank_id).delete
    true
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false
  end

  def update_source(params, card_or_bank_id, type)
    source = stripe_customer.sources.retrieve(card_or_bank_id)
    set_card_source_attributes(source, params) if type == 'credit_card'
    set_bank_source_attributes(source, params) if type == 'checking'
    true
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false 
  end

  def set_default_source(token)
    customer = stripe_customer
    customer.default_source = token
    customer.save
    true
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false
  end

  def default_source
    stripe_customer.default_source
  end

  def retrieve
    stripe_customer
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    []
  end

  def sources
    stripe_customer.sources.data
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    []
  end

  def subscriptions
    stripe_customer.subscriptions.data
  end

  private

  attr_accessor :user
  def stripe_create_customer
    Stripe::Customer.create(
      email: user.email,
      description: "Frishtug customer ##{user.id}, #{user.full_name} <#{user.email}>",
      source: user.stripe_token
    )
  end

  def stripe_customer
    Stripe::Customer.retrieve(user.stripe_customer_id)
  end

  def set_card_source_attributes(source, params)
    source.name             = params[:name]
    source.address_line1    = params[:address_line1]
    source.address_line2    = params[:address_line2]
    source.address_city     = params[:address_city]
    source.address_state    = params[:address_state]
    source.address_country  = 'US'
    source.address_zip      = params[:address_zip]
    source.exp_month        = params[:exp_month]
    source.exp_year         = params[:exp_year]
    source.save
  end

  def set_bank_source_attributes(source, params)
    source.account_holder_name = params[:account_holder_name]
    source.account_holder_type = params[:account_holder_type]
    source.save
  end
end
