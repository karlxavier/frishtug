class Admin::SuggestionsController < Admin::BaseController
  def index
    @suggestions = Comment.all.page(page).per(20)
  end

  def show
    @suggestion = Comment.find(params[:id])
  end

  private

  def page
    params[:page]
  end
end