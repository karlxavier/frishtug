class PlanCommenter
  attr_reader :plan, :comment_body, :user_id
  def initialize(plan_id, comment_body, user_id)
    @plan = Plan.find_by_id(plan_id)
    @comment_body = comment_body
    @user_id = user_id
  end

  def self.call(plan_id:, comment_body:, user_id:)
    self.new(plan_id, comment_body, user_id).create_comment
  end

  def create_comment
    return nil if comment_body.blank?
    plan.comments.create!(body: comment_body, user_id: user_id)
  end
end