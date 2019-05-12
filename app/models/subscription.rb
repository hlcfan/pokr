class Subscription < ApplicationRecord
  belongs_to :user

  DELETED = 0
  ACTIVE  = 1

  def active?
    ACTIVE == self.status
  end

  def plan_name
    plans[subscription_plan_id][:name]
  end

  private

  def plans
    {
      "542882" => { name: "Monthly subscription - Trial" },
      "557854" => { name: "Monthly subscription" },
      "555649" => { name: "Quaterly subscription - Trial" },
      "557854" => { name: "Monthly subscription" },
      "552848" => { name: "Yearly subscription - Trial" },
      "557856" => { name: "Yearly subscription" }
    }
  end
end
