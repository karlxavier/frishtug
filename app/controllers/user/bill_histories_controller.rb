class User::BillHistoriesController < User::BaseController
  def index
    @bill_histories = BillHistoryService.new(current_user).run
  end
end