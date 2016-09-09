require "rails_helper"

RSpec.describe FeedbackMailer, type: :mailer do
  describe "feedback" do
    let(:mail) { FeedbackMailer.feedback(email: "a@a.com", message: "message").deliver_now }

    it "renders the subject" do
      expect(mail.subject).to eq "[Feedback] Pokrex"
    end

    it "renders the receiver email" do
      expect(mail.to).to eq ["hlcfan.yan@gmail.com"]
    end

    it "renders the sender email" do
      expect(mail.from).to eq ["no-reply@pokrex.com"]
    end

    it "assigns @email" do
      expect(mail.body.encoded).to match "a@a.com"
      expect(mail.body.encoded).to match "message"
    end

    it "assigns @message" do
      expect(mail.body.encoded).to match "message"
    end
  end
end