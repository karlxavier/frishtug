module Admin::SuggestionsHelper
  def suggestion_for(comment)
    commentable = comment.commentable
    case comment.commentable_type
    when "Order"
      return link_to "Order ##{commentable.id}", admin_order_path(commentable.id)
    when "Plan"
      return link_to "Plan #{commentable.name}", admin_plan_path(commentable.id)
    end
  end
end
