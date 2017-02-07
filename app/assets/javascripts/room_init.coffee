#= require action_cable
#= require react
#= require react_ujs
#= require marked
#= require components

$(document).on "turbolinks:load", ->
  $(".rooms.show").ready ->
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