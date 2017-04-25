#= require page_init
#= require action_cable
#= require marked

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
    # ReactOnRails.render("Room", {poker: POKER}, 'room')
    setupChannelSubscription()
    return