require 'rails_helper'

RSpec.describe BillingController, type: :controller do

  describe "#show" do
    login_user

    it "renders show template" do
      get :show
      expect(response).to render_template("show")
    end

    it "assigns @orders" do
      user = User.find_by email: "a@a.com"
      order = Order.create(name: "Monthly subscription", user_id: user.id, price: 7.0, quantity: 2)
      get :show
      expect(assigns(:orders)).to eq([order])
    end
  end

end
