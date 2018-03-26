class Admin::SearchResultsController < Admin::BaseController
  def index
    @results = SearchResult.search(search_term)
  end

  private

  def search_term
    params[:search_term]
  end
end