class PaymentMethodForm
  include ActiveModel::Model
  attr_accessor :type, :credit_card, :checking, :user
  validate :user_is_object?

  def save
    return false if invalid?
    persist!
  end

  def update
    return false if invalid?
    persist_update!
  end

  private

  def persist_update!
    ActiveRecord::Base.transaction do
      if type == 'credit_card'
        card_or_bank_id = credit_card[:token]
        cc = CreditCard.find_by_stripe_id(card_or_bank_id)
        credit_card.delete :token
        cc.update_attributes!(credit_card)
        update_stripe_customer(card_or_bank_id)
      else
        card_or_bank_id = checking[:token]
        bank = Checking.find_by_stripe_id(card_or_bank_id)
        checking.delete :token
        bank.update_attributes!(checking)
        update_stripe_customer(card_or_bank_id)
      end
    end
    true
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:base, e.message)
    false
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  def persist!
    ActiveRecord::Base.transaction do
      if type == 'credit_card'
        user.credit_cards.create!(credit_card)
        create_stripe_customer(credit_card[:token])
      else
        user.checkings.create!(checking)
        create_stripe_customer(checking[:token])
      end
    end
    true
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:base, e.message)
    false
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  def user_is_object?
    user.is_a?(ActiveRecord::Base)
  end

  def create_stripe_customer(token)
    customer = StripeCustomer.new(user)
    source = customer.add_source(token)
    if customer.errors.count > 0
      errors.add(:base, customer.errors.full_messages.join(', '))
      raise ActiveRecord::StatementInvalid
    end
    user_payment_method = user.credit_cards.where(token: token).first || user.checkings.where(token: token).first
    user_payment_method.update_attributes!(stripe_id: source.id)
  end

  def update_stripe_customer(card_or_bank_id)
    customer = StripeCustomer.new(user)
    param = if type == 'credit_card'
              {
                name: credit_card[:name],
                exp_year: credit_card[:year],
                exp_month: credit_card[:month],
                cvc: credit_card[:cvc],
                address_line1: credit_card[:address_attributes][:line1],
                address_line2: credit_card[:address_attributes][:line2],
                address_city: credit_card[:address_attributes][:city],
                address_zip: credit_card[:address_attributes][:zip_code],
                address_state: credit_card[:address_attributes][:state]
              }
            else
              {
                account_holder_name: checking[:account_holder_name],
                account_holder_type: checking[:account_holder_type]
              }
           end
    customer.update_source(param, card_or_bank_id, type)
    if customer.errors.count > 0
      errors.add(:base, customer.errors.full_messages.join(', '))
      raise ActiveRecord::StatementInvalid
    end
  end
end
