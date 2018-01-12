module Guest
  extend ActiveSupport::Concern

  included do
    helper_method :current_or_guest_user, :guest_user?
  end

  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).try(:reload).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end

  def guest_user?
    session[:guest_user_id].present?
  end

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # For example:
    # guest_comments = guest_user.comments.all
    # guest_comments.each do |comment|
      # comment.user_id = current_user.id
      # comment.save!
    # end
  end

  def create_guest_user
    username = params[:username].to_s.parameterize
    raise ArgumentError "Invalid username" if username.blank?
    u = User.create(:name => username, :email => "#{username}_#{Time.now.to_i}#{rand(100)}@pokrex.com")
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end
end