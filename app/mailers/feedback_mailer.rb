class FeedbackMailer < ApplicationMailer

  def feedback email:, message:
    @message = message
    @email = email
    mail(to: "hlcfan.yan@gmail.com", subject: '[Feedback] Pokrex')
  end

end
