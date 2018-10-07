require 'rails_helper'

# spec/support/message_delivery.rb
class ActionMailer::MessageDelivery
  def deliver_later
    deliver_now
  end
end

RSpec.describe MarketingController, type: :controller do

  describe "POST #send_email" do
    it "sends emails to valid receivers" do
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      expect(ManualMailer).to receive(:create).with(to: "c@c.com", message: "message").and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_later)
      post :send_email, params: { receivers: "c@c.com", content: "message" }
      expect(response.status).to eq 200
    end
  end

  describe "GET #send_email" do
    it "renders send_email template" do
      get :send_email
      expect(response).to render_template("send_email")
    end
  end

end
