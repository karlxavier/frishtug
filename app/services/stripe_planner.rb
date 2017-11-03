class StripePlanner
  include ActiveModel::Validations

  def initialize(plan)
    @plan = plan
  end

  def run
    stripe_plan = Stripe::Plan.create(
      amount: format_to_cent(@plan.price),
      interval: @plan.interval,
      name: @plan.name,
      currency: 'usd',
      id: @plan.name.parameterize
    )

    @plan.update_attributes(
      stripe_plan_id: stripe_plan.id
    )
  end

  private

  def format_to_cent(amount)
    (amount * 100).to_i
  end
end