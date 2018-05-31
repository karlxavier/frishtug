class RecordPayments
  prepend SimpleCommand

  def initialize(order, amount, type)
    @order = order
    @amount = amount
    @type = type
    @description = {
      'excess' => "Excess Charge",
      'tax' => "Tax Charge"
    }
  end

  def call
    @order.bill_histories.create!(
      amount_paid: @amount,
      user_id: @order.user_id,
      description: @description[@type],
      billed_at: @order.placed_on
    )
    @order.paid!
  end
end