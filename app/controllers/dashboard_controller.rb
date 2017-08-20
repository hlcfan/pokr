class DashboardController < ApplicationController

  before_action :authenticate_user!

  def index
    @user = UserPresenter.new(current_user)
  end

  def participated_rooms
    
  end

  def created_rooms
    
  end

end
