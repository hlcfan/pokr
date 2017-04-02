class UsersController < ApplicationController

  before_action :authenticate_user!

  def autocomplete
    query = params[:term]
    head :bad_request and return if query.blank?

    users = User.where("name like ? OR email like ?", "#{query}%", "#{query}%").pluck(:id, :name).map do |id, name|
      next if id == current_user.id
      { id: id, label: name, value: name }
    end.compact

    render json: users
  end

end