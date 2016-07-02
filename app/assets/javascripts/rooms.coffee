# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:change', ->
  if POKER? && POKER.roomId?
    storyListUrl = '/rooms/' + POKER.roomId + '/story_list.json'
    peopleListUrl = '/rooms/' + POKER.roomId + '/user_list.json'
    POKER.storyListUrl = '/rooms/' + POKER.roomId + '/story_list.json'
    POKER.peopleListUrl = '/rooms/' + POKER.roomId + '/user_list.json'
    POKER.pointsRange = [
      0
      2
      3
      5
      8
      13
      20
      40
      100
      'coffee'
    ]
    POKER.story_id = do ->
      $('.storyList ul li:first').data 'id'
    # Initialize sync result as false
    window.syncResult = (POKER.roomState == 'open') ? true : false
    window.client = new (Faye.Client)('/faye')

    element = React.createElement(Room, poker: POKER)
    ReactDOM.render(element, document.getElementById('room'))
    return
