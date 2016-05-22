class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

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

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

end
