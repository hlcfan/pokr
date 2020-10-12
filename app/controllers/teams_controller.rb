class TeamsController < ApplicationController

  before_action :authenticate_user!

  def show
    @teams = Team.find_by_user(current_user)
  end

end
