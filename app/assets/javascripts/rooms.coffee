# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require action_cable
#= require react
#= require react_ujs
#= require marked
#= require components

$(document).on 'turbolinks:load', ->
  if POKER.page.controller_name == "rooms" & POKER.page.action_name == "show"
    POKER.roomId = $('#roomId').val()
    POKER.roomName = $('#roomName').val()
    POKER.role = $('#role').val()
    POKER.currentVote = $('#currentVote').val()
    POKER.roomState = $('#roomState').val()
    POKER.pointValues = JSON.parse($('#pointValues').val())
    POKER.timerInterval = parseFloat($('#timerInterval').val())
    POKER.freeStyle = JSON.parse($('#freeStyle').val())

    if POKER? && POKER.roomId?
      window.App = {}
      App.cable = ActionCable.createConsumer()
      POKER.storyListUrl = '/rooms/' + POKER.roomId + '/story_list.json'
      POKER.peopleListUrl = '/rooms/' + POKER.roomId + '/user_list.json'
      POKER.story_id = do ->
        $('.storyList ul li:first').data 'id'

      window.syncResult = (POKER.roomState == 'open') ? true : false
      element = React.createElement(Room, poker: POKER)
      ReactDOM.render(element, document.getElementById('room'))
      setupChannelSubscription()
      return

    $('.import').on 'click', ->
    if $('.import').data('status') == 'input'
      $('#story-row .row').hide()
      $('.btn.add').hide()
      $('.bulk-links').show()
      $('#bulk').val true
      $('.import').data 'status', 'bulk'
    else
      $('#story-row .row').show()
      $('.btn.add').show()
      $('.bulk-links').hide()
      $('#bulk').val false
      $('.import').data 'status', 'input'
    return
