class UsersController < ApplicationController

  before_action :authenticate_user!

  def autocomplete
    query = params[:term]
    head :bad_request and return if query.blank?

    users = User.where("name like ? OR email like ?", "#{query}%", "#{query}%").pluck(:id, :name).map do |id, name|
      next if id == current_user.id
      { value: id, name: name }
    end.compact

    render json: users
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

end
