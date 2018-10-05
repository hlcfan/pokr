class ManualMailer < ApplicationMailer

  default from: "hlcfan.yan@gmail.com" # , "Message-ID" => -> {"<#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@pokrex.com>"}
  layout 'mailer'

  def create to:, message:
    @message = message
    @to = to
    mail(to: to, subject: 'Alex from Pokrex')
  end

end
