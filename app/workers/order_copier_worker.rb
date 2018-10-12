  class OrderCopierWorker
  include Sidekiq::Worker

  def perform(user_id)
    new_order_ids = []
    user = User.find_by_id(user_id)
    if user
      FullMonthOrderCopier.call(user)      
    end
  end
end
