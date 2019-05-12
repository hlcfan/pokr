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
    unless trial?
      subscription = Subscription.where(user_id: current_user.id).last
      subscription&.plan_name
    else
      "Free"
    end
  end

  def pricing_select_options
    Subscription.plans.map do |plan, plan_detail|
      content_tag(:option, value: plan, trial_plan_id: plan_detail[:trial], normal_plan_id: plan_detail[:normal]) do
        "#{plan_detail[:name]} - $#{plan_detail[:fee]}"
      end
    end.join.html_safe
  end

  private def trial?
    return false
    Time.now - current_user.created_at <= 30.days
  end
end
