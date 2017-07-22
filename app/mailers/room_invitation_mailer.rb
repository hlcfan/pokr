class RoomInvitationMailer < ApplicationMailer

  def invite from_name:, from_email:, to:, room_name:, room_slug:
    @from_name = from_name
    @from_email = from_email
    @to = to
    @room_name = room_name
    @room_slug = room_slug
    mail(to: to, subject: "#{from_name} has invited you to join room #{room_name}")
  end
end
