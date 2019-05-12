module BillingHelper
  def allow_to_create_schems?
    current_user.premium? || (!current_user.premium? && current_user.schemes.count < 1)
  end

  def upgrade_button_text
    if trial?
      "Try free for 30 days"
    else
      "Upgrade"
    end
  end

  def billing_plan_category
    if trial?
      "trial"
    else
      "normal"
    end
  end

  def billing_plan
    if current_user.premium?
      subscription = Subscription.where(user_id: current_user.id).last
      subscription&.plan_name
    else
      "Free"
    end
  end

  private def trial?
    Time.now - current_user.created_at <= 30.days
  end
end
