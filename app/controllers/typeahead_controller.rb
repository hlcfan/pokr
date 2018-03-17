class TypeaheadController < ApplicationController
  include StoryHelper

  before_action :authenticate_user!

  def index
    query = params[:query]
    head :bad_request and return if query.blank?
    searches = PgSearch.multisearch(query).limit(10)
    searches = searches.map do |search_object|
      story_or_room = search_object.searchable
      if story_or_room.related_to_user? current_user.id
        search_object.searchable
      end
    end.group_by { |search| search.class }

    render json: format_typeahead_data(searches)
  end

  private

  def format_typeahead_data data
    array = []
    (data[Story] || []).each do |json_object|
      array << {
        type:      "ticket",
        title:     json_object["link"],
        sub_title: json_object["desc"],
        indicator: symbol_point_hash(json_object["point"]),
        link: room_path(Room.find(json_object["room_id"]).slug)
      }
    end
    (data[Room] || []).each do |json_object|
      array << {
        type:      "group",
        title:     json_object["name"],
        sub_title: json_object["created_at"].strftime("%Y-%d-%m"),
        indicator: "",
        link: room_path(json_object["slug"])
      }
    end

    array
  end
end
