module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = User.create(name: 'alex', email: 'a@a.com', password: 'password')
      sign_in user
    end
  end

  def method_name
    
  end
end