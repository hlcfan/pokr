class Billing
  show: ->
    plans = {
      monthly: { trial: "542882", normal: "557854" }
      quaterly: { trial: "555649", normal: "557855" }
      yearly: { trial: "552848", normal: "557856" }
      enterprise: { trial: "557853", normal: "557853" }
    }

    upgradeButton = document.getElementById("paddle-button")
    billingPlanCategory = document.getElementById("billing-plan-category").value
    previousButtonText = upgradeButton.text

    $(".billing__plan-dropdown").on "change", ->
      plan = (plans[this.value] || plans["monthly"])[billingPlanCategory]
      console.log("Plan:" + plan)
      upgradeButton.setAttribute("data-product", plan)

      if this.value == "enterprise"
        upgradeButton.text = "Upgrade"
      else
        upgradeButton.text = previousButtonText

$(document).on "ready", ->
  $(".billing.show").ready ->
    billing = new Billing
    billing.show()

