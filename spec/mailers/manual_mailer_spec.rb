require "rails_helper"

RSpec.describe ManualMailer, type: :mailer do
  describe ".create" do
    let(:mail) { ManualMailer.create(to: "a@a.com", message: "message").deliver_now }

    it "renders the subject" do
      expect(mail.subject).to eq "Alex from Pokrex"
    end

    it "renders the receiver email" do
      expect(mail.to).to eq ["a@a.com"]
    end

    it "renders the sender email" do
      expect(mail.from).to eq ["hlcfan.yan@gmail.com"]
    end

    it "populates the email message id" do
      expect(mail.message_id).to match /(.*)@pokrex.com/
    end

    it "assigns @message" do
      expect(mail.body.encoded).to match "Hope you're doing well."
    end
  end
end
