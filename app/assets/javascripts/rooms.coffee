# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require action_cable

$(document).on 'turbolinks:load', ->
  if POKER? && POKER.roomId?
    window.App = {}
    App.cable = ActionCable.createConsumer()
    storyListUrl = '/rooms/' + POKER.roomId + '/story_list.json'
    peopleListUrl = '/rooms/' + POKER.roomId + '/user_list.json'
    POKER.storyListUrl = '/rooms/' + POKER.roomId + '/story_list.json'
    POKER.peopleListUrl = '/rooms/' + POKER.roomId + '/user_list.json'
    POKER.story_id = do ->
      $('.storyList ul li:first').data 'id'
    # Initialize sync result as false
    window.syncResult = (POKER.roomState == 'open') ? true : false

    element = React.createElement(Room, poker: POKER)
    ReactDOM.render(element, document.getElementById('room'))
    return
