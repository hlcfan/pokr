class Billing
  calcAmount = ->
    totalAmount = $(".plan__month-select").val() * 7
    $(".plan__amount").text("$" + totalAmount.toFixed(2))

  init: ->
    calcAmount()
    $('.plan__month-select').on 'change', ->
      calcAmount()
      return

$(document).on "ready", ->
  $(".billing.show").ready ->
    billing = new Billing
    billing.init()
