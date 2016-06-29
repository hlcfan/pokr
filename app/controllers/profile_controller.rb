class ProfileController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user

  def show

  end

  def edit
    
  end

  def update
    if @user.update_attributes profile_params
      redirect_to profile_path, flash: { success: 'Your profile updated successfully' }
    else
      render :show
    end
  end

  private

  def set_user
    @user = current_user
  end

  def profile_params
    params.require(:user).permit(:name)
  end

end
