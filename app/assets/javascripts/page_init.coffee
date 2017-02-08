# Place basic variables here

POKER = window['POKER'] = {}
$(document).on 'turbolinks:load', (event) ->
  POKER.currentUser = name: $('.dropdown-toggle').text().trim()
  return