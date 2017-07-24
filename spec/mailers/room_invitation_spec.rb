require "rails_helper"

RSpec.describe RoomInvitationMailer, type: :mailer do
  describe "invite" do
    let(:mail) { RoomInvitationMailer.invite(
      from_name: "Alex",
      from_email: "no-reply@pokrex.com", to: "bob@b.com",
      room_name: "Good day", room_slug: "good-day"
      ).deliver_now
    }

    it "renders the subject" do
      expect(mail.subject).to eq "Alex has invited you to join room Good day"
    end

    it "renders the receiver email" do
      expect(mail.to).to eq ["bob@b.com"]
    end

    it "renders the sender email" do
      expect(mail.from).to eq ["no-reply@pokrex.com"]
    end

    it "populates the email message id" do
      expect(mail.message_id).to match /(.*)@pokrex.com/
    end

    it "assigns @from_name, @from_email, @room_name, @room_slug:" do
      expect(mail.body.encoded).to match "Alex"
      expect(mail.body.encoded).to match "no-reply@pokrex.com"
      expect(mail.body.encoded).to match "Good day"
      expect(mail.body.encoded).to match "good-day"
    end
  end
end
