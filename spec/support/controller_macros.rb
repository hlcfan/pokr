module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = User.create(name: 'alex', email: 'a@a.com', password: 'password')
      sign_in user
    end
  end

  def login_guest(guest = false)
    guest ||= begin
      u = User.create(:name => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@pokrex.com")
      u.save!(:validate => false)
      u
    end
    @request.session[:guest_user_id] = guest.id
  end
end