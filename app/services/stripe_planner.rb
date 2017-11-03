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

  def retrieve
    return false if stripe_plan_id?
    Stripe::Plan.retrieve(@plan.stripe_plan_id)
  end

  def delete
    stripe_plan = retrieve
    if stripe_plan
      stripe_plan.delete
      true
    end

    false
  end

private

  attr_accessor :plan
  def stripe_plan_id?
    unless plan.stripe_plan_id?
      errors.add(:plan, 'has no equivalent stripe plan')
      true
    end
    false
  end

  def format_to_cent(amount)
    (amount * 100).to_i
  end
end