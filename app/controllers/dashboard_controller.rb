class DashboardController < ApplicationController

  before_action :authenticate_user!

  def index
    @user = UserPresenter.new(current_user)
  end

end
