class RecordPayments
  prepend SimpleCommand

  def initialize(order, amount, type, charge_id)
    @order = order
    @amount = amount
    @type = type
    @charge_id = charge_id
    @description = {
      'excess': "Excess Charge",
      'tax': "Tax Charge",
      'shipping': "Shipping Charge",
    }
  end

  def call
    @order.bill_histories.create!(
      amount_paid: @amount,
      user_id: @order.user_id,
      description: @description[@type.to_sym],
      billed_at: @order.placed_on,
      charge_id: @charge_id,
    )
    @order.paid!
  end
end
