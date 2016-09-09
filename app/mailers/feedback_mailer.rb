class FeedbackMailer < ApplicationMailer

  def feedback message, email
    @message = message
    @email = email
    mail(to: "hlcfan.yan@gmail.com", subject: '[Feedback] Pokrex')
  end

end
