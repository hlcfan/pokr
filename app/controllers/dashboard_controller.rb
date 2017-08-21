class DashboardController < ApplicationController

  before_action :authenticate_user!

  def index
    @user = user_presenter
  end

  def room_list
    user = user_presenter
    @rooms = user.participated_rooms(params[:page].to_i)
  end

  private

  def user_presenter
    UserPresenter.new(current_user)
  end

end
