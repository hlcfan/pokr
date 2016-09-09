class HomeController < ApplicationController

  def index
    redirect_to dashboard_index_path and return if current_user
    render layout: false
  end

  def sign_up
    cookies[:email] = params[:email]
    redirect_to new_user_registration_path
  end

  def feedback
    message = params[:feedback]
    email = params[:email] || current_user.email
    if message.present? && email.present?
      FeedbackMailer.feedback(@user).deliver_later
    end
  end

end
