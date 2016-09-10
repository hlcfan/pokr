require 'rails_helper'
# spec/support/message_delivery.rb
class ActionMailer::MessageDelivery
  def deliver_later
    deliver_now
  end
end

RSpec.describe HomeController, type: :controller do
  
  describe "GET #index" do
    context "when user signed in" do
      login_user

      it "redirects user to dashboard if user signed in" do
        get :index
        expect(response).to redirect_to dashboard_index_path
      end
    end

    context "when user does not signed in" do
      render_views
      it "renders home page" do
        get :index
        expect(response.body).to match /<h1>/
        expect(response).to render_template "index", layout: false
      end
    end
  end

  describe "POST #feedback" do
    context "when user is not signed in" do
      it "collects feedback and send to me" do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(FeedbackMailer).to receive(:feedback).with(email: "c@c.com", message: "feedback").and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)
        post :feedback, params: { email: "c@c.com", feedback: "feedback" }
        expect(response.status).to eq 204
      end
    end

    context "when user signed in" do
      login_user
      it "collects feedback and send to me" do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(FeedbackMailer).to receive(:feedback).with(email: "a@a.com", message: "feedback").and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)
        post :feedback, params: { email: "c@c.com", feedback: "feedback" }
        expect(response.status).to eq 204
      end
    end

    context "when empty message or empty email sent" do
      it "does not collects feedback if empty message" do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(message_delivery).not_to receive(:deliver_later)
        expect(FeedbackMailer).not_to receive(:feedback)
        post :feedback, params: { email: "c@c.com", feedback: "" }
        expect(response.status).to eq 204
      end

      it "does not collects feedback if empty email address" do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(message_delivery).not_to receive(:deliver_later)
        expect(FeedbackMailer).not_to receive(:feedback)
        post :feedback, params: { email: "", feedback: "feedback" }
        expect(response.status).to eq 204
      end
    end
  end

end
