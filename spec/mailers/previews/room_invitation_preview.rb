# Preview all emails at http://localhost:3000/rails/mailers/room_invitation
class RoomInvitationPreview < ActionMailer::Preview
  def invite
    RoomInvitationMailer.invite(
      from_name: "Alex",
      from_email: "no-reply@pokrex.com",
      to: "bob@b.com",
      room_name: "Good day",
      room_slug: "good-day"
    )
  end
end
