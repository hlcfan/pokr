class ProfileController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user

  def show

  end

  def update
    if @user.update_attributes profile_params
      redirect_to profile_path, flash: { success: 'Your profile updated successfully' }
    else
      render :show
    end
  end

  def update_password
    if @user.valid_password? params[:user][:current_password]
      if @user.update(password_params)
        # Sign in the user by passing validation in case their password changed
        bypass_sign_in @user
        redirect_to profile_path, flash: { success: 'Your password updated successfully' }
      else
        render :show
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def profile_params
    params[:user][:name] = params[:user][:name][0..20]
    params.require(:user).permit(:name, :avatar)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
