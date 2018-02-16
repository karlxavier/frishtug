class User::BillHistoriesController < User::BaseController
  def index
    bill_histories = BillHistoryService.new(current_user).run
    @bill_histories = Kaminari.paginate_array(bill_histories.data).page(page).per(10)
  end

  private

  def page
  	params[:page]
  end
end