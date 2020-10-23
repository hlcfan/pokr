class TeamsController < ApplicationController

  before_action :authenticate_user!

  def index
    @teams = Team.find_by_user(current_user)
  end

end
