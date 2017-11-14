class StripeCustomer
  include ActiveModel::Validations

  def initialize(user)
    @user = user
  end

  def add_source(token)
    stripe_customer.sources.create(source: token)
    stripe_customer.save
    true
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false 
  end

  def remove_source(token)
    stripe_customer.sources.retrieve(token).delete
    true
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false 
  end

  def set_default_source(token)
    stripe_customer.default_source = token
    stripe_customer.save
  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    false 
  end

  private

  def stripe_customer
    Stripe::Customer.retrieve(@user.stripe_customer_id)
  end
end