class Subscription < ApplicationRecord
  belongs_to :user

  DELETED = 0
  ACTIVE  = 1

  def active?
    ACTIVE == self.status
  end

  def plan_name
    plan = self.plans.values.find{ |h| h[:trial] == subscription_plan_id || h[:normal] == subscription_plan_id }
    plan[:name] || "Unknow plan"
  end

  def self.plans
    {
      "monthly":    { trial: "542882", normal: "557854", name: "Monthly subscription", fee: 7 },
      "quaterly":   { trial: "555649", normal: "557855", name: "Quaterly subscription", fee: 20 },
      "yearly":     { trial: "552848", normal: "557856", name: "Yearly subscription", fee: 77 },
      "enterprise": { trial: "557853", normal: "557853", name: "Enterprise subscription", fee: 200 }
    }
  end
end
