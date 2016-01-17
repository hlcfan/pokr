class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= begin
      user_id = cookies[:user_id]
      User.find user_id
    rescue ActiveRecord::RecordNotFound => e
      cookies.delete :user_id
      nil
    end
  end
  helper_method :current_user

  def current_story
    @current_story ||= begin
      story_id = cookies[:story_id]
      Story.find story_id
    rescue ActiveRecord::RecordNotFound => e
      cookies.delete :story_id
      nil
    end
  end
  helper_method :current_story

end
