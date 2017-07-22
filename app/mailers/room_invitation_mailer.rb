class RoomInvitationMailer < ApplicationMailer

  def invite from:, to:, room:
    @to = to
    mail(to: email_address, subject: "#{from} has invited you to join room #{room}")
  end
end
