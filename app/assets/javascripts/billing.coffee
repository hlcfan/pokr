class Billing
  show: ->
    upgradeButton = document.getElementById("paddle-button")

    if upgradeButton
      billingPlanCategory = document.getElementById("billing-plan-category").value
      previousButtonText = upgradeButton.text

      $(".billing__plan-dropdown").on "change", ->
        plan = this.querySelector(":checked").getAttribute(billingPlanCategory + "_plan_id") || "557854"
        console.log("Plan: " + plan)
        upgradeButton.setAttribute("data-product", plan)

        if this.value == "enterprise"
          upgradeButton.text = "Upgrade"
        else
          upgradeButton.text = previousButtonText


$(document).on "ready", ->
  $(".billing.show").ready ->
    billing = new Billing
    billing.show()

