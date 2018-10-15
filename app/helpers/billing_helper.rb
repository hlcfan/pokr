module BillingHelper
  def allow_to_create_schems?
    current_user.premium? || (!current_user.premium? && current_user.schemes.count < 1)
  end
end
