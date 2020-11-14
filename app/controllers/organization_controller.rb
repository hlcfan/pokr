class OrganizationController < ApplicationController
  before_action :authenticate_user!, except: [:screen]

  def show
    if current_user.user_organization.present?
      @org = Organization.members(current_user.user_organization.organization_id).first
    end

  end
end
