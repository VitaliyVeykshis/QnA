class SearchController < ApplicationController
  skip_after_action :verify_authorized

  expose :category, -> { set_category }

  def search
    @results = search_results
    render :index
  end

  private

  def set_category
    params[:category].classify.constantize unless params[:category].casecmp('all').zero?
  end

  def search_results
    {
      query: params[:query],
      data: GetSearchResults.call(query: params[:query], category: category).results
    }
  end
end
