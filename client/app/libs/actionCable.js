import EventEmitter from 'libs/eventEmitter'
import BarColors from 'libs/barColors'

window.App = {}

export default {
  setupChannelSubscription(roomId, roomState) {
    if (roomState === "draw") {
      return false
    }

    App.cable = ActionCable.createConsumer()

    App.rooms = App.cable.subscriptions.create({channel: 'RoomsChannel', room: roomId}, {
      connected: function(){
      },
      received: function(data) {
        console.dir(data)
        if (data.type === 'action') {
          if (data.data === 'open') {
            window.syncResult = true
            roomState = 'open'
            showResultSection()
          } else if (data.data === 'refresh-users') {
            if ($("#u-" + data.user_id).length <= 0) {
              EventEmitter.dispatch("refreshUsers")
            }
          } else if(data.data === "next-story") {
            nextStory()
          } else if(data.data === "revote") {
            revote()
          } else if(data.data === "close-room") {
            EventEmitter.dispatch("roomClosed")
          } else if(data.data === "switch-roles") {
            EventEmitter.dispatch("refreshUsers")
          } else if(data.data === "clear-votes") {
            nextStory()
          }
        } else if(data.type === 'notify') {
          var $personElement = $('#u-' + data.person_id)
          if ($personElement.hasClass('voted')) {
            $personElement.removeClass("voted")
          }
          setTimeout(function(){
            $personElement.addClass("voted", 100)
          }, 200)

          window.syncResult = data.sync
          if (syncResult) {
            $('#u-' + data.person_id + ' .points').text(BarColors.emoji(data.points) || data.points)
            $('#u-' + data.person_id).attr('data-point', data.points)
          }
          EventEmitter.dispatch("refreshUsers")
        } else {

        }
      }
    })
  }
}