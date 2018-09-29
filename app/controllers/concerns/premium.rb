module Premium
  extend ActiveSupport::Concern

  def premium_check redirection_path, message, *conditions
    if conditions.all? { |condition| true == condition }
      redirect_to(redirection_path, flash: { alert: message }) and return
    end
  end
end
