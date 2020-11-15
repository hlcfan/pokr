class OrganizationController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.user_organization.present?
      @org = Organization.members(current_user.user_organization.organization_id).first
    end
  end

  def switch_admin
    current_user_org = current_user.user_organization

    head :unauthorized and return if current_user_org.blank? || !UserOrganization.admin?(current_user_org.role)

    if !OrganizationRoleUpdater.switch_admin(current_user_org.organization_id, params[:organization_id], params[:uid])
      head :bad_request

      return
    end

    @org = Organization.members(current_user_org.organization_id).first

    respond_to do |format|
      format.json { head :no_content }
      format.js
    end
  end

end
