class PaymentMethodForm
  include ActiveModel::Model
  attr_accessor :type, :credit_card, :checking, :user
  validate :user_is_object?

  def save
    return false if invalid?
    persist!
  end

  private

  def persist!
    ActiveRecord::Base.transaction do
      if type == 'credit_card'
        user.credit_cards.create!(credit_card)
        update_stripe_customer(credit_card[:token])
      else
        user.checkings.create!(checking)
        update_stripe_customer(checking[:token])
      end
    end
    true
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:base, e.message)
    false
  end

  def user_is_object?
    user.is_a?(ActiveRecord::Base)
  end

  def update_stripe_customer(token)
    customer = StripeCustomer.new(user)
    customer.add_source(token)
    raise ActiveRecord::Rollback if customer.errors.count > 0
  end
end