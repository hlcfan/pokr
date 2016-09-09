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
    if message.present? && client_email_address.present?
      FeedbackMailer.feedback(email: client_email_address, message: message).deliver_later
    end

    head :no_content
  end

  private

  def client_email_address
    @client_email_address ||= begin
      if current_user
        current_user.email
      else
        params[:email]
      end
    end
  end

end
