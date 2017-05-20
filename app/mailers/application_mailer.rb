class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@pokrex.com", "Message-ID" => -> {"<#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@pokrex.com>"}
  layout 'mailer'
end

