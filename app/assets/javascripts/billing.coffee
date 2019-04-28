class Billing
  show: ->
    plans = {
      monthly: "542882",
      quaterly: "555649",
      yearly: "552848",
      enterprise: "557853"
    }

    upgradeButton = document.getElementById("paddle-button")
    previousButtonText = upgradeButton.text

    $(".billing__plan-dropdown").on "change", ->
      plan = plans[this.value] || plans["monthly"]
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

