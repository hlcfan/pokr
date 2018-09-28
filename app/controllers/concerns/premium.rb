module Premium
  extend ActiveSupport::Concern

  def premium_check message, *conditions
    if !current_user.premium? && conditions.all? { |condition| true == condition }
      redirect_to(billing_path, flash: { notice: message }) and return
    end
  end
end
