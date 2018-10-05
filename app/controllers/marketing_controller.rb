class MarketingController < ApplicationController

  def send_email
    if request.post?
      receivers = params[:receivers]&.split(",")
      content = params[:content]
      receivers.each do |receiver|
        next unless receiver.present? && receiver =~ User::VALID_EMAIL_REGEX
        ManualMailer.create(to: receiver, message: content).deliver_later
      end

      flash[:success] = "Sent!"
    end
  end
end
