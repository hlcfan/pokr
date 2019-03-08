import EventEmitter from 'libs/eventEmitter'
import BarColors from 'libs/barColors'
import RoomActions from 'libs/roomActions'
import ActionCable from 'actioncable'

window.App = {}

export default {
  setupChannelSubscription(roomId) {
    MessageBus.start()
    MessageBus.callbackInterval = 500

    MessageBus.subscribe(`rooms/${roomId}`, function(data){
      console.dir(data)
      if (data.type === 'action') {
        if (data.data === 'open') {
          RoomActions.showResultSection()
        } else if (data.data === 'refresh-users') {
          if ($("#u-" + data.user_id).length <= 0) {
            EventEmitter.dispatch("refreshUsers")
          }
        } else if(data.data === "next-story") {
          RoomActions.nextStory()
        } else if(data.data === "revote") {
          RoomActions.nextStory()
        } else if(data.data === "close-room") {
          EventEmitter.dispatch("roomClosed")
        } else if(data.data === "switch-roles") {
          EventEmitter.dispatch("refreshUsers")
        } else if(data.data === "clear-votes") {
          RoomActions.nextStory()
        }
      } else if(data.type === 'notify') {
        if (window.syncResult) {
          EventEmitter.dispatch("refreshUsers")
        }
        // Must keep for now
        var $personElement = $('#u-' + data.person_id)
        if ($personElement.hasClass('voted')) {
          $personElement.removeClass("voted")
        }
        setTimeout(function(){
          $personElement.addClass("voted", 100)
        }, 200)
      } else if(data.type === "evictUser") {
        EventEmitter.dispatch("evictUser", data.data.userId)
        EventEmitter.dispatch("refreshUsers")
      } else {
      }
    })

    MessageBus.publish = function(action, payload) {
      console.log(`${action}:${payload}`)
      fetch(`/rooms/${action}`, {
        body: JSON.stringify(payload),
        method: "POST",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      })
        .then(data => {
          console.log(data)
        })
        .catch(error => {
          console.error(error)
        })
    }
  }
}
