class TypeaheadController < ApplicationController
  def index
    query = params[:query]
    head :bad_request and return if query.blank?
    searches = PgSearch.multisearch(query).limit(10)
    searches = searches.map do |search_object|
      search_object.searchable
    end.group_by { |search| search.class }

    render json: searches
  end
end
