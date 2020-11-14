class OrganizationController < ApplicationController
  before_action :authenticate_user!, except: [:screen]

  def show
    @org = current_user.organization
  end
end
